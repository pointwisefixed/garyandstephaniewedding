@GuestForm = React.createClass
  getInitialState: ->
    first_name: ''
    last_name: ''
    email: ''
    password: ''
    username: ''
		can_bring_plus_one: false
		rsvp_edit_dateline: ''
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', {guest: @state}, (data) =>
      @props.handleNewGuest data
      @setState @getInitialState()
    , 'JSON'
  handleChange: (e) ->
    name  = e.target.name
    @setState "#{ name }": e.target.value
  valid: ->
    @state.first_name && @state.last_name
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'First name'
          name: 'first_name'
          value: @state.first_name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Last name'
          className: 'form-control'
          name: 'last_name'
          value: @state.last_name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'Email'
          className: 'form-control'
          name: 'email'
          value: @state.email
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'Username'
          className: 'form-control'
          name: 'username'
          value: @state.username
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'password'
          className: 'form-control'
          name: 'password'
          value: @state.password
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'can_bring_plus_one'
          'Can Bring plus one?'
        React.DOM.input
          type: 'checkbox'
          className: 'form-control'
          name: 'can_bring_plus_one'
          value: @state.can_bring_plus_one
          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Add Guest'
