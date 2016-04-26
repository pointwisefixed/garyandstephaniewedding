@WeddingInfoForm = React.createClass
  getInitialState: ->
    hisInformation: @props.weddingInfo.hisInformation
    herInformation: @props.weddingInfo.herInformation
    ourStory: @props.weddingInfo.ourStory
    ourFirstMeeting: @props.weddingInfo.ourFirstMeeting
    ourFirstDate: @props.weddingInfo.ourFirstDate
    theRing: @props.weddingInfo.theRing
    weddingInfoId: @props.weddingInfo.id
    proposal: @props.weddingInfo.proposal
    whenAndWhereIsTheWedding: @props.weddingInfo.whenAndWhereIsTheWedding
    ceremony: @props.weddingInfo.ceremony
    reception: @props.weddingInfo.reception
    accomodations: @props.weddingInfo.accomodations
    attending: @props.weddingInfo.attending
    ourGallery: @props.weddingInfo.ourGallery
    dontMissIt: @props.weddingInfo.dontMissIt
    moreEvents: @props.weddingInfo.moreEvents
    dancingParty: @props.weddingInfo.dancingParty
    flowerAndFlowers: @props.weddingInfo.flowerAndFlowers
    groomsmen: @props.weddingInfo.groomsmen
    bestMan: @props.weddingInfo.bestMan
    bestFriend: @props.weddingInfo.bestFriend
    bridesmaid: @props.weddingInfo.bridesmaid
    maidOfHonor: @props.weddingInfo.maidOfHonor
    bestBrideFriend: @props.weddingInfo.bestBrideFriend
    bestfriendbridesmaid: @props.weddingInfo.bestfriendbridesmaid
    giftRegistry: @props.weddingInfo.giftRegistry
    rsvpInfo: @props.weddingInfo.rsvpInfo

  handleUpdate: (e) ->
    e.preventDefault()
    $.ajax
      method: 'PUT',
      url: "/admin/#{ @state.weddingInfoId }"
      dataType: 'JSON'
      data:
        weddingInfo: @state
  handleChange: (e) ->
    name = e.target.name
    @setState "#{name}" : e.target.value
  render: ->
     React.DOM.form
        className: 'form-vertical'
        onSubmit: @handleUpdate
        React.DOM.div
          className: 'form-group'
          React.DOM.label
            htmlFor: 'hisInformation'
            className: 'control-label'
            'His Information'
          React.DOM.textarea
            className: 'form-control'
            name: 'hisInformation'
            rows: 10
            placeholder: 'His Information'
            value: @state.hisInformation
            onChange: @handleChange

          React.DOM.label
            htmlFor: 'herInformation'
            className: 'control-label'
            'Her Information'
          React.DOM.textarea
            className: 'form-control'
            name: 'herInformation'
            rows: 10
            placeholder: 'Her Information'
            value: @state.herInformation
            onChange: @handleChange

           React.DOM.label
            htmlFor: 'ourStory'
            className: 'control-label'
            'Our Story'
          React.DOM.textarea
            className: 'form-control'
            name: 'ourStory'
            rows: 10
            placeholder: 'Our Story'
            value: @state.ourStory
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'ourFirstMeeting'
            className: 'control-label'
            'How we met!'
          React.DOM.textarea
            className: 'form-control'
            name: 'ourFirstMeeting'
            rows: 10
            placeholder: 'We met...'
            value: @state.ourFirstMeeting
            onChange: @handleChange

          React.DOM.label
            htmlFor: 'ourFirstDate'
            className: 'control-label'
            'First Date!!'
          React.DOM.textarea
            className: 'form-control'
            name: 'ourFirstDate'
            rows: 10
            placeholder: 'Our first date took place ...'
            value: @state.ourFirstDate
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'theRing'
            className: 'control-label'
            'The Ring!'
          React.DOM.textarea
            className: 'form-control'
            name: 'theRing'
            rows: 10
            placeholder: 'The ring description...'
            value: @state.theRing
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'proposal'
            className: 'control-label'
            'The Proposal!'
          React.DOM.textarea
            className: 'form-control'
            name: 'proposal'
            rows: 10
            placeholder: 'How the proposal happened'
            value: @state.proposal
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'whenAndWhereIsTheWedding'
            className: 'control-label'
            'When and where is the ceremony!'
          React.DOM.textarea
            className: 'form-control'
            name: 'whenAndWhereIsTheWedding'
            rows: 10
            placeholder: 'When and where is the ceremony'
            value: @state.whenAndWhereIsTheWedding
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'ceremony'
            className: 'control-label'
            'The ceremony'
          React.DOM.textarea
            className: 'form-control'
            name: 'ceremony'
            rows: 10
            placeholder: 'The ceremony information'
            value: @state.ceremony
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'reception'
            className: 'control-label'
            'The Reception'
          React.DOM.textarea
            className: 'form-control'
            name: 'reception'
            rows: 10
            placeholder: 'The Reception information'
            value: @state.reception
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'accomodations'
            className: 'control-label'
            'The Accomodation'
          React.DOM.textarea
            className: 'form-control'
            name: 'accomodations'
            rows: 10
            placeholder: 'The Accomodation information'
            value: @state.accomodations
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'attending'
            className: 'control-label'
            'The Attending'
          React.DOM.textarea
            className: 'form-control'
            name: 'attending'
            rows: 10
            placeholder: 'The Attending information'
            value: @state.attending
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'ourGallery'
            className: 'control-label'
            'Our Gallery'
          React.DOM.textarea
            className: 'form-control'
            name: 'ourGallery'
            rows: 10
            placeholder: 'Our Gallery information'
            value: @state.ourGallery
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'dontMissIt'
            className: 'control-label'
            'Do not miss it!'
          React.DOM.textarea
            className: 'form-control'
            name: 'dontMissIt'
            rows: 10
            placeholder: 'Do not miss it because ...'
            value: @state.dontMissIt
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'moreEvents'
            className: 'control-label'
            'More Events'
          React.DOM.textarea
            className: 'form-control'
            name: 'moreEvents'
            rows: 10
            placeholder: 'More Events Info'
            value: @state.moreEvents
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'dancingParty'
            className: 'control-label'
            'Dancing Pary'
          React.DOM.textarea
            className: 'form-control'
            name: 'dancingParty'
            rows: 10
            placeholder: 'Dancing Pary Info'
            value: @state.dancingParty
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'flowerAndFlowers'
            className: 'control-label'
            'Flower And Flowers'
          React.DOM.textarea
            className: 'form-control'
            name: 'flowerAndFlowers'
            rows: 10
            placeholder: 'Flowers Info'
            value: @state.flowerAndFlowers
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'groomsmen'
            className: 'control-label'
            'Groomsmen'
          React.DOM.textarea
            className: 'form-control'
            name: 'groomsmen'
            rows: 10
            placeholder: 'Groomsmen info'
            value: @state.groomsmen
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'bestMan'
            className: 'control-label'
            'Best Man'
          React.DOM.textarea
            className: 'form-control'
            name: 'bestMan'
            rows: 10
            placeholder: 'Best Man info'
            value: @state.bestMan
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'bestFriend'
            className: 'control-label'
            'Best Friend'
          React.DOM.textarea
            className: 'form-control'
            name: 'bestFriend'
            rows: 10
            placeholder: 'Best Friend info'
            value: @state.bestFriend
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'bridesmaid'
            className: 'control-label'
            'Bridesmaid'
          React.DOM.textarea
            className: 'form-control'
            name: 'bridesmaid'
            rows: 10
            placeholder: 'Bridesmaid info'
            value: @state.bridesmaid
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'maidOfHonor'
            className: 'control-label'
            'Maid Of Honor'
          React.DOM.textarea
            className: 'form-control'
            name: 'maidOfHonor'
            rows: 10
            placeholder: 'Maid Of Honor info'
            value: @state.maidOfHonor
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'bestBrideFriend'
            className: 'control-label'
            'Groom\'s sister'
          React.DOM.textarea
            className: 'form-control'
            name: 'bestBrideFriend'
            rows: 10
            placeholder: 'Groom\'s sister info'
            value: @state.bestBrideFriend
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'bestfriendbridesmaid'
            className: 'control-label'
            'Best Friend of the Friend '
          React.DOM.textarea
            className: 'form-control'
            name: 'bestfriendbridesmaid'
            rows: 10
            placeholder: 'Best Friend of the Bride info'
            value: @state.bestfriendbridesmaid
            onChange: @handleChange
           React.DOM.label
            htmlFor: 'giftRegistry'
            className: 'control-label'
            'Gift Registry Info'
          React.DOM.textarea
            className: 'form-control'
            name: 'giftRegistry'
            rows: 10
            placeholder: 'Gift Registry info'
            value: @state.giftRegistry
            onChange: @handleChange
          React.DOM.label
            htmlFor: 'rsvpInfo'
            className: 'control-label'
            'RSVP Info'
          React.DOM.textarea
            className: 'form-control'
            name: 'rsvpInfo'
            rows: 10
            placeholder: 'RSVP info'
            value: @state.rsvpInfo
            onChange: @handleChange
          React.DOM.button
            type: 'submit'
            className: 'btn btn-primary'
            'Update Wedding Info'
