var hmds = new Vue({
  el: '#hmds',
  data: {
    hmds: []
  },
  mounted: function() {
    var view;
    view = this;
    $.ajax({
      url: '/hmds.json',
      success: function(res) {
        view.hmds = res;
      }
    });
  }
});


Vue.component('hmd-row', {
  template: '#hmd-row',
  props: {
    hmd: Object
  },
  data: function () {
    return {
      thestate: this.hmd['state'],
      editmode: false,
      errors: {}
    }
  },
  methods: {
    updateState: function() {
      var view;
      view = this;
      view.hmd.state = view.thestate;
      $.ajax({
        method: 'PUT',
        data: {
          hmd: view.hmd
        },
        url: '/hmds/' + view.hmd.id + '.json',
        success: function(res) {
          view.errors = {};
          view.thestate = res['state'];
          view.editmode = false;
        },
        errors: function(res) {
          view.errors = res.responseJSON.errors;
        }
      });
    }
  }
});