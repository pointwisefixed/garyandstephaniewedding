(function() {
  this.Dropdown = React.createClass({
    displayName: 'Dropdown',
    propTypes: {
      id: React.PropTypes.string.isRequired,
      options: React.PropTypes.array.isRequired,
      value: React.PropTypes.oneOfType([React.PropTypes.number, React.PropTypes.string]),
      disabled: React.PropTypes.string,
      valueField: React.PropTypes.string,
      labelField: React.PropTypes.string,
      onChange: React.PropTypes.func
    },
    getDefaultProps: function() {
      return {
        value: null,
        valueField: 'value',
        labelField: 'label',
        onChange: null,
        disabled: ''
      };
    },
    getInitialState: function() {
      var disabled, selected;
      selected = this.getSelectedFromProps(this.props);
      disabled = null;
      if (!!this.props.disabled) {
        disabled = this.props.disabled;
        return {
          selected: selected,
          disabled: disabled
        };
      } else {
        return {
          selected: selected
        };
      }
    },
    componentWillReceiveProps: function(nextProps) {
      var selected;
      selected = this.getSelectedFromProps(nextProps);
      this.setState({
        selected: selected
      });
    },
    getSelectedFromProps: function(props) {
      var selected;
      selected = void 0;
      if (props.value === null && props.options.length !== 0) {
        selected = props.options[0][props.valueField];
      } else {
        selected = props.value;
      }
      return selected;
    },
    render: function() {
      var options, selectAttributes, self;
      self = this;
      options = self.props.options.map(function(option) {
        return React.createElement('option', {
          key: option[self.props.valueField],
          value: option[self.props.valueField]
        }, option[self.props.labelField]);
      });
      selectAttributes = {
        id: this.props.id,
        className: 'form-control',
        value: this.state.selected,
        onChange: this.handleChange
      };
      if (!!this.props.disabled) {
        selectAttributes['disabled'] = 'disabled';
      }
      return React.createElement('select', selectAttributes, options);
    },
    handleChange: function(e) {
      var change;
      if (this.props.onChange) {
        change = {
          oldValue: this.state.selected,
          newValue: e.target.value
        };
        this.props.onChange(change);
      }
      this.setState({
        selected: e.target.value
      });
    }
  });

}).call(this);
(function() {
  this.Guest = React.createClass({
    getInitialState: function() {
      return {
        edit: false,
        entree_id: this.props.guest.entree_id,
        first_name: this.props.guest.first_name,
        last_name: this.props.guest.last_name,
        attending: this.props.guest.attending,
        plusone: this.props.guest.plusone,
        admin: this.props.guest.admin,
        username: this.props.guest.username,
        email: this.props.guest.email,
        plus_one_entree_id: this.props.guest.plus_one_entree_id,
        guest_id: this.props.guest.id
      };
    },
    handleToggle: function(e) {
      e.preventDefault();
      return this.setState({
        edit: !this.state.edit
      });
    },
    handleDelete: function(e) {
      e.preventDefault();
      return $.ajax({
        method: 'DELETE',
        url: "/guests/" + this.state.guest_id,
        dataType: 'JSON',
        success: (function(_this) {
          return function() {
            return _this.props.handleDeleteGuest(_this.state.guest_id, _this.state.attending, _this.state.plusone);
          };
        })(this)
      });
    },
    onDropdownChange: function(c) {
      return this.setState({
        entree_id: c.newValue
      });
    },
    onPlusOneDropdownChange: function(c) {
      return this.setState({
        plus_one_entree_id: c.newValue
      });
    },
    onFirstNameChange: function(c) {
      return this.setState({
        first_name: c.target.value
      });
    },
    onLastNameChange: function(c) {
      return this.setState({
        last_name: c.target.value
      });
    },
    onUsernameChange: function(c) {
      return this.setState({
        username: c.target.value
      });
    },
    onAttendingChange: function(c) {
      return this.setState({
        attending: c.target.checked
      });
    },
    onPlusoneChange: function(c) {
      return this.setState({
        plusone: c.target.checked
      });
    },
    onEmailChange: function(c) {
      return this.setState({
        email: c.target.value
      });
    },
    onAdminChange: function(c) {
      return this.setState({
        admin: c.target.checked
      });
    },
    handleEdit: function(e) {
      var data;
      e.preventDefault();
      data = {
        first_name: this.state.first_name,
        last_name: this.state.last_name,
        username: this.state.username,
        email: this.state.email,
        attending: this.state.attending,
        plusone: this.state.plusone,
        entree_id: this.state.entree_id,
        plus_one_entree_id: this.state.plus_one_entree_id,
        id: this.state.guest_id
      };
      return $.ajax({
        method: 'PUT',
        url: "/guests/" + this.state.guest_id,
        dataType: 'JSON',
        data: {
          guest: data
        },
        success: (function(_this) {
          return function(data) {
            _this.setState({
              edit: false
            });
            return _this.props.handleEditGuest(_this.state.guest_id, data);
          };
        })(this)
      });
    },
    guestRow: function() {
      return React.DOM.tr(null, React.DOM.td(null, this.state.first_name), React.DOM.td(null, this.state.last_name), React.DOM.td(null, this.state.username), React.DOM.td(null, this.state.email), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        disabled: 'disabled',
        checked: this.state.attending
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        disabled: 'disabled',
        checked: this.state.plusone
      })), React.DOM.td(null, React.createElement(Dropdown, {
        id: 'entree',
        disabled: 'disabled',
        options: this.props.entrees,
        value: this.state.entree_id,
        labelField: 'description',
        valueField: 'id'
      }), React.createElement(Dropdown, {
        id: 'plus_one_entree',
        disabled: 'disabled',
        options: this.props.entrees,
        value: this.state.plus_one_entree_id,
        labelField: 'description',
        valueField: 'id'
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        disabled: 'disabled',
        defaultChecked: this.state.admin
      })), React.DOM.td(null, React.DOM.a({
        className: 'btn btn-default',
        onClick: this.handleToggle
      }, 'Edit'), React.DOM.a({
        className: 'btn btn-danger',
        onClick: this.handleDelete
      }, 'Delete')));
    },
    guestForm: function() {
      return React.DOM.tr(null, React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'text',
        value: this.state.first_name,
        onChange: this.onFirstNameChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'text',
        value: this.state.last_name,
        onChange: this.onLastNameChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'text',
        value: this.state.username,
        onChange: this.onUsernameChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'text',
        value: this.state.email,
        onChange: this.onEmailChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        checked: this.state.attending,
        onChange: this.onAttendingChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        checked: this.state.plusone,
        onChange: this.onPlusoneChange
      })), React.DOM.td(null, React.createElement(Dropdown, {
        id: 'entree_change',
        options: this.props.entrees,
        value: this.state.entree_id,
        labelField: 'description',
        valueField: 'id',
        onChange: this.onDropdownChange
      }), React.createElement(Dropdown, {
        id: 'plus_one_entree_change',
        options: this.props.entrees,
        value: this.state.plus_one_entree_id,
        labelField: 'description',
        valueField: 'id',
        onChange: this.onPlusOneDropdownChange
      })), React.DOM.td(null, React.DOM.input({
        className: 'form-control',
        type: 'checkbox',
        checked: this.state.admin,
        onChange: this.onAdminChange
      })), React.DOM.td(null, React.DOM.a({
        className: 'btn btn-default',
        onClick: this.handleEdit
      }, 'Update'), React.DOM.a({
        className: 'btn btn-danger',
        onClick: this.handleToggle
      }, 'Cancel')));
    },
    render: function() {
      if (this.state.edit) {
        return this.guestForm();
      } else {
        return this.guestRow();
      }
    }
  });

}).call(this);
(function() {
  this.GuestForm = React.createClass({
    getInitialState: function() {
      return {
        first_name: '',
        last_name: '',
        email: '',
        password: '',
        username: '',
        can_bring_plus_one: false,
        rsvp_edit_dateline: '',
        attending: false,
        plusone: false,
        entree_id: 0,
        plus_one_entree_id: 0
      };
    },
    handleSubmit: function(e) {
      e.preventDefault();
      return $.post('', {
        guest: this.state
      }, (function(_this) {
        return function(data) {
          _this.props.handleNewGuest(data);
          return _this.setState(_this.getInitialState());
        };
      })(this), 'JSON');
    },
    handleChange: function(e) {
      var name, obj;
      name = e.target.name;
      return this.setState((
        obj = {},
        obj["" + name] = e.target.value,
        obj
      ));
    },
    handleAttendingChange: function(c) {
      return this.setState({
        "attending": c.target.checked
      });
    },
    handlePlusOneChange: function(c) {
      return this.setStaet({
        "plusone": c.target.checked
      });
    },
    handleEntreeChange: function(e) {
      return this.setState({
        "entree_id": e.newValue
      });
    },
    handlePlusOneEntreeChange: function(e) {
      return this.setState({
        "plus_one_entree_id": e.newValue
      });
    },
    valid: function() {
      return this.state.first_name && this.state.last_name;
    },
    render: function() {
      return React.DOM.form({
        className: 'form-horizontal',
        onSubmit: this.handleSubmit
      }, React.DOM.div({
        className: 'form-group'
      }, React.DOM.input({
        type: 'text',
        className: 'form-control',
        placeholder: 'First name',
        name: 'first_name',
        value: this.state.first_name,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.input({
        type: 'text',
        className: 'form-control',
        placeholder: 'Last name',
        className: 'form-control',
        name: 'last_name',
        value: this.state.last_name,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.input({
        type: 'text',
        placeholder: 'Email',
        className: 'form-control',
        name: 'email',
        value: this.state.email,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.input({
        type: 'text',
        placeholder: 'Username',
        className: 'form-control',
        name: 'username',
        value: this.state.username,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.input({
        type: 'text',
        placeholder: 'password',
        className: 'form-control',
        name: 'password',
        value: this.state.password,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'can_bring_plus_one'
      }, 'Can Bring Plus one?'), React.DOM.input({
        type: 'checkbox',
        className: 'form-control',
        name: 'Can Bring Plus_one',
        value: this.state.can_bring_plus_one,
        onChange: this.handleChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'rsvp'
      }, 'rsvp?'), React.DOM.input({
        type: 'checkbox',
        className: 'form-control',
        name: 'RSVP?',
        value: this.state.attending,
        onChange: this.onAttendingChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'plus_one'
      }, 'plus one?'), React.DOM.input({
        type: 'checkbox',
        className: 'form-control',
        name: 'Plus_one',
        value: this.state.plusone,
        onChange: this.onPlusoneChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'entree_id'
      }, 'Guest Entree'), React.createElement(Dropdown, {
        id: 'entree_id',
        options: this.props.entrees,
        value: this.state.entree_id,
        labelField: 'description',
        valueField: 'id',
        onChange: this.handleEntreeChange
      })), React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'plus_one_entree_id'
      }, 'Plus One Entree'), React.createElement(Dropdown, {
        id: 'plus_one_entree_id',
        options: this.props.entrees,
        value: this.state.plus_one_entree_id,
        labelField: 'description',
        valueField: 'id',
        onChange: this.handlePlusOneEntreeChange
      })), React.DOM.button({
        type: 'submit',
        className: 'btn btn-primary',
        disabled: !this.valid()
      }, 'Add Guest'));
    }
  });

}).call(this);
(function() {
  this.Guests = React.createClass({
    getInitialState: function() {
      return {
        guests: this.props.data,
        attending_count: this.props.attending_count
      };
    },
    getDefaultProps: function() {
      return {
        guests: []
      };
    },
    addGuest: function(guest) {
      var guests;
      guests = React.addons.update(this.state.guests, {
        $push: [guest]
      });
      this.setState({
        entrees: this.props.entrees
      });
      this.setState({
        attending_count: this.props.attending_count
      });
      return this.setState({
        guests: guests
      });
    },
    deleteGuest: function(guest_id, guest_attending, guest_plusone) {
      var attendingCount, guests, i, index, j, len, ref, value;
      index = -1;
      ref = this.state.guests;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        value = ref[i];
        if (value.id === guest_id) {
          index = i;
          break;
        }
      }
      attendingCount = this.state.attending_count;
      if (guest_attending) {
        attendingCount = attendingCount - 1;
      }
      if (guest_plusone) {
        attendingCount = attendingCount - 1;
      }
      guests = React.addons.update(this.state.guests, {
        $splice: [[index, 1]]
      });
      this.setState({
        entrees: this.props.entrees
      });
      this.setState({
        attending_count: attendingCount
      });
      return this.setState({
        guests: guests
      });
    },
    updateGuest: function(guest_id, data) {
      var guests, i, index, j, len, ref, value;
      index = -1;
      ref = this.state.guests;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        value = ref[i];
        if (value.id === guest_id) {
          index = i;
          break;
        }
      }
      guests = React.addons.update(this.state.guests, {
        $splice: [[index, 1, data]]
      });
      $.ajax({
        method: 'GET',
        url: "/guests/count",
        dataType: 'JSON',
        success: (function(_this) {
          return function(data) {
            return _this.setState({
              attending_count: data
            });
          };
        })(this)
      });
      this.setState({
        entrees: this.props.entrees
      });
      return this.setState({
        guests: guests
      });
    },
    render: function() {
      var guest;
      return React.DOM.div({
        className: 'guests container'
      }, React.DOM.h2({
        className: 'title'
      }, 'Guests'), React.createElement(GuestForm, {
        handleNewGuest: this.addGuest,
        entrees: this.props.entrees
      }), React.DOM.hr(null), React.DOM.table({
        className: 'table table-bordered'
      }, React.DOM.thead(null, React.DOM.tr(null, React.DOM.th(null, 'First Name'), React.DOM.th(null, 'Last Name'), React.DOM.th(null, 'Username'), React.DOM.th(null, 'Email'), React.DOM.th(null, 'RSVP?'), React.DOM.th(null, 'Plus one?'), React.DOM.th(null, 'Food Selection'), React.DOM.th(null, 'Is Admin?'), React.DOM.th(null, 'Action'))), React.DOM.tbody(null, (function() {
        var j, len, ref, results;
        ref = this.state.guests;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          guest = ref[j];
          results.push(React.createElement(Guest, {
            key: guest.id,
            guest: guest,
            entrees: this.props.entrees,
            handleDeleteGuest: this.deleteGuest,
            handleEditGuest: this.updateGuest
          }));
        }
        return results;
      }).call(this), React.DOM.tr(null, React.DOM.td(null, 'Total guests attending'), React.DOM.td(null, this.state.attending_count)))));
    }
  });

}).call(this);
(function() {
  this.WeddingInfo = React.createClass({
    getInitialState: function() {
      return {
        weddingInfo: this.props.data
      };
    },
    render: function() {
      return React.DOM.div({
        className: 'weddingInfo container'
      }, React.DOM.h2({
        className: 'title'
      }, 'Wedding'), React.createElement(WeddingInfoForm, {
        weddingInfo: this.state.weddingInfo
      }), React.DOM.hr(null));
    }
  });

}).call(this);
(function() {
  this.WeddingInfoForm = React.createClass({
    getInitialState: function() {
      return {
        hisInformation: this.props.weddingInfo.hisInformation,
        herInformation: this.props.weddingInfo.herInformation,
        ourStory: this.props.weddingInfo.ourStory,
        ourFirstMeeting: this.props.weddingInfo.ourFirstMeeting,
        ourFirstDate: this.props.weddingInfo.ourFirstDate,
        theRing: this.props.weddingInfo.theRing,
        weddingInfoId: this.props.weddingInfo.id,
        proposal: this.props.weddingInfo.proposal,
        whenAndWhereIsTheWedding: this.props.weddingInfo.whenAndWhereIsTheWedding,
        ceremony: this.props.weddingInfo.ceremony,
        reception: this.props.weddingInfo.reception,
        accomodations: this.props.weddingInfo.accomodations,
        attending: this.props.weddingInfo.attending,
        ourGallery: this.props.weddingInfo.ourGallery,
        dontMissIt: this.props.weddingInfo.dontMissIt,
        moreEvents: this.props.weddingInfo.moreEvents,
        dancingParty: this.props.weddingInfo.dancingParty,
        flowerAndFlowers: this.props.weddingInfo.flowerAndFlowers,
        groomsmen: this.props.weddingInfo.groomsmen,
        bestMan: this.props.weddingInfo.bestMan,
        bestFriend: this.props.weddingInfo.bestFriend,
        bridesmaid: this.props.weddingInfo.bridesmaid,
        maidOfHonor: this.props.weddingInfo.maidOfHonor,
        bestBrideFriend: this.props.weddingInfo.bestBrideFriend,
        bestfriendbridesmaid: this.props.weddingInfo.bestfriendbridesmaid,
        giftRegistry: this.props.weddingInfo.giftRegistry,
        rsvpInfo: this.props.weddingInfo.rsvpInfo
      };
    },
    handleUpdate: function(e) {
      e.preventDefault();
      return $.ajax({
        method: 'PUT',
        url: "/admin/" + this.state.weddingInfoId,
        dataType: 'JSON',
        data: {
          weddingInfo: this.state
        }
      });
    },
    handleChange: function(e) {
      var name, obj;
      name = e.target.name;
      return this.setState((
        obj = {},
        obj["" + name] = e.target.value,
        obj
      ));
    },
    render: function() {
      return React.DOM.form({
        className: 'form-vertical',
        onSubmit: this.handleUpdate
      }, React.DOM.div({
        className: 'form-group'
      }, React.DOM.label({
        htmlFor: 'hisInformation',
        className: 'control-label'
      }, 'His Information'), React.DOM.textarea({
        className: 'form-control',
        name: 'hisInformation',
        rows: 10,
        placeholder: 'His Information',
        value: this.state.hisInformation,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'herInformation',
        className: 'control-label'
      }, 'Her Information'), React.DOM.textarea({
        className: 'form-control',
        name: 'herInformation',
        rows: 10,
        placeholder: 'Her Information',
        value: this.state.herInformation,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'ourStory',
        className: 'control-label'
      }, 'Our Story'), React.DOM.textarea({
        className: 'form-control',
        name: 'ourStory',
        rows: 10,
        placeholder: 'Our Story',
        value: this.state.ourStory,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'ourFirstMeeting',
        className: 'control-label'
      }, 'How we met!'), React.DOM.textarea({
        className: 'form-control',
        name: 'ourFirstMeeting',
        rows: 10,
        placeholder: 'We met...',
        value: this.state.ourFirstMeeting,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'ourFirstDate',
        className: 'control-label'
      }, 'First Date!!'), React.DOM.textarea({
        className: 'form-control',
        name: 'ourFirstDate',
        rows: 10,
        placeholder: 'Our first date took place ...',
        value: this.state.ourFirstDate,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'theRing',
        className: 'control-label'
      }, 'The Ring!'), React.DOM.textarea({
        className: 'form-control',
        name: 'theRing',
        rows: 10,
        placeholder: 'The ring description...',
        value: this.state.theRing,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'proposal',
        className: 'control-label'
      }, 'The Proposal!'), React.DOM.textarea({
        className: 'form-control',
        name: 'proposal',
        rows: 10,
        placeholder: 'How the proposal happened',
        value: this.state.proposal,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'whenAndWhereIsTheWedding',
        className: 'control-label'
      }, 'When and where is the ceremony!'), React.DOM.textarea({
        className: 'form-control',
        name: 'whenAndWhereIsTheWedding',
        rows: 10,
        placeholder: 'When and where is the ceremony',
        value: this.state.whenAndWhereIsTheWedding,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'ceremony',
        className: 'control-label'
      }, 'The ceremony'), React.DOM.textarea({
        className: 'form-control',
        name: 'ceremony',
        rows: 10,
        placeholder: 'The ceremony information',
        value: this.state.ceremony,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'reception',
        className: 'control-label'
      }, 'The Reception'), React.DOM.textarea({
        className: 'form-control',
        name: 'reception',
        rows: 10,
        placeholder: 'The Reception information',
        value: this.state.reception,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'accomodations',
        className: 'control-label'
      }, 'The Accomodation'), React.DOM.textarea({
        className: 'form-control',
        name: 'accomodations',
        rows: 10,
        placeholder: 'The Accomodation information',
        value: this.state.accomodations,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'attending',
        className: 'control-label'
      }, 'The Attending'), React.DOM.textarea({
        className: 'form-control',
        name: 'attending',
        rows: 10,
        placeholder: 'The Attending information',
        value: this.state.attending,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'ourGallery',
        className: 'control-label'
      }, 'Our Gallery'), React.DOM.textarea({
        className: 'form-control',
        name: 'ourGallery',
        rows: 10,
        placeholder: 'Our Gallery information',
        value: this.state.ourGallery,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'dontMissIt',
        className: 'control-label'
      }, 'Do not miss it!'), React.DOM.textarea({
        className: 'form-control',
        name: 'dontMissIt',
        rows: 10,
        placeholder: 'Do not miss it because ...',
        value: this.state.dontMissIt,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'moreEvents',
        className: 'control-label'
      }, 'More Events'), React.DOM.textarea({
        className: 'form-control',
        name: 'moreEvents',
        rows: 10,
        placeholder: 'More Events Info',
        value: this.state.moreEvents,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'dancingParty',
        className: 'control-label'
      }, 'Dancing Pary'), React.DOM.textarea({
        className: 'form-control',
        name: 'dancingParty',
        rows: 10,
        placeholder: 'Dancing Pary Info',
        value: this.state.dancingParty,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'flowerAndFlowers',
        className: 'control-label'
      }, 'Flower And Flowers'), React.DOM.textarea({
        className: 'form-control',
        name: 'flowerAndFlowers',
        rows: 10,
        placeholder: 'Flowers Info',
        value: this.state.flowerAndFlowers,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'groomsmen',
        className: 'control-label'
      }, 'Groomsmen'), React.DOM.textarea({
        className: 'form-control',
        name: 'groomsmen',
        rows: 10,
        placeholder: 'Groomsmen info',
        value: this.state.groomsmen,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'bestMan',
        className: 'control-label'
      }, 'Best Man'), React.DOM.textarea({
        className: 'form-control',
        name: 'bestMan',
        rows: 10,
        placeholder: 'Best Man info',
        value: this.state.bestMan,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'bestFriend',
        className: 'control-label'
      }, 'Best Friend'), React.DOM.textarea({
        className: 'form-control',
        name: 'bestFriend',
        rows: 10,
        placeholder: 'Best Friend info',
        value: this.state.bestFriend,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'bridesmaid',
        className: 'control-label'
      }, 'Bridesmaid'), React.DOM.textarea({
        className: 'form-control',
        name: 'bridesmaid',
        rows: 10,
        placeholder: 'Bridesmaid info',
        value: this.state.bridesmaid,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'maidOfHonor',
        className: 'control-label'
      }, 'Maid Of Honor'), React.DOM.textarea({
        className: 'form-control',
        name: 'maidOfHonor',
        rows: 10,
        placeholder: 'Maid Of Honor info',
        value: this.state.maidOfHonor,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'bestBrideFriend',
        className: 'control-label'
      }, 'Groom\'s sister'), React.DOM.textarea({
        className: 'form-control',
        name: 'bestBrideFriend',
        rows: 10,
        placeholder: 'Groom\'s sister info',
        value: this.state.bestBrideFriend,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'bestfriendbridesmaid',
        className: 'control-label'
      }, 'Best Friend of the Friend '), React.DOM.textarea({
        className: 'form-control',
        name: 'bestfriendbridesmaid',
        rows: 10,
        placeholder: 'Best Friend of the Bride info',
        value: this.state.bestfriendbridesmaid,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'giftRegistry',
        className: 'control-label'
      }, 'Gift Registry Info'), React.DOM.textarea({
        className: 'form-control',
        name: 'giftRegistry',
        rows: 10,
        placeholder: 'Gift Registry info',
        value: this.state.giftRegistry,
        onChange: this.handleChange
      }), React.DOM.label({
        htmlFor: 'rsvpInfo',
        className: 'control-label'
      }, 'RSVP Info'), React.DOM.textarea({
        className: 'form-control',
        name: 'rsvpInfo',
        rows: 10,
        placeholder: 'RSVP info',
        value: this.state.rsvpInfo,
        onChange: this.handleChange
      }), React.DOM.button({
        type: 'submit',
        className: 'btn btn-primary'
      }, 'Update Wedding Info')));
    }
  });

}).call(this);
