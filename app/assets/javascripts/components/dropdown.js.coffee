@Dropdown = React.createClass(
  displayName: 'Dropdown'
  propTypes:
    id: React.PropTypes.string.isRequired
    options: React.PropTypes.array.isRequired
    value: React.PropTypes.oneOfType([
      React.PropTypes.number
      React.PropTypes.string
    ])
    disabled: React.PropTypes.string
    valueField: React.PropTypes.string
    labelField: React.PropTypes.string
    onChange: React.PropTypes.func
  getDefaultProps: ->
    {
      value: null
      valueField: 'value'
      labelField: 'label'
      onChange: null
    }
  getInitialState: ->
    selected = @getSelectedFromProps(@props)
    disabled = @props.disabled
    { selected: selected, disabled: disabled }
  componentWillReceiveProps: (nextProps) ->
    selected = @getSelectedFromProps(nextProps)
    @setState selected: selected
    return
  getSelectedFromProps: (props) ->
    selected = undefined
    if props.value == null and props.options.length != 0
      selected = props.options[0][props.valueField]
    else
      selected = props.value
    selected
  render: ->
    self = this
    options = self.props.options.map((option) ->
      React.createElement 'option', {
        key: option[self.props.valueField]
        value: option[self.props.valueField]
      }, option[self.props.labelField]
    )
    React.createElement 'select', {
      id: @props.id
      className: 'form-control'
      value: @state.selected
      onChange: @handleChange
      disabled: @state.disabled
    }, options
  handleChange: (e) ->
    if @props.onChange
      change = 
        oldValue: @state.selected
        newValue: e.target.value
      @props.onChange change
    @setState selected: e.target.value
    return
)
