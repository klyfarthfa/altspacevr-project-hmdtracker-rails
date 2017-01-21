class UseAuditedStateForHmds < ActiveRecord::Migration
  def change
    reversible do |d|
      d.up {
        execute <<-SQL
          INSERT INTO hmd_states(hmd_id,  state, created_at, updated_at)
          SELECT id, state, NOW(), NOW() FROM hmds
        SQL
        execute <<-SQL
          INSERT INTO hmd_states(hmd_id,  state, created_at, updated_at)
          SELECT id, 'announced', announced_at, announced_at FROM hmds
          WHERE hmds.state != 'announced'
        SQL
        remove_column :hmds, :state
      }
      d.down {
        add_column :hmds, :state, :string, :limit => 64
        execute <<-SQL
          UPDATE hmds
          SET state = t.state
          FROM (
            SELECT st.hmd_id, st.state FROM hmd_states AS st
            INNER JOIN (SELECT hmd_id, MAX(created_at) AS max_date FROM hmd_states GROUP BY hmd_id) AS tm
            ON st.hmd_id = tm.hmd_id AND st.created_at = tm.max_date
          ) AS t
          WHERE id = t.hmd_id
        SQL
        execute <<-SQL
          TRUNCATE TABLE hmd_states
        SQL
      }
    end
  end
end
