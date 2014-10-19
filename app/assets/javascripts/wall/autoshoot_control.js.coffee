#= require ./event_emitter

class @AutoshootControl extends EventEmitter
  constructor: (@$dom) ->
    super
    @initialClass = @$dom.attr('class')
    @remainingSeconds = '?'
    @setState('WAITING_PERMISSIONS')

    @$dom.on 'click', (e) =>
      e.stopPropagation()
      e.preventDefault()

      nextState = if @state == 'COUNTDOWN'
        'PAUSED'
      else if @state == 'PAUSED'
        'COUNTDOWN'

      @emit('requestStateChange', nextState) if nextState

  setState: (state) ->
    @state = state

    template = if state == 'COUNTDOWN'
      """
        <span>
          <span class='autoshoot-control__normal'>Photo in #{@remainingSeconds}...</span>
          <span class='autoshoot-control__hover'>Pause</span>
        </span>
      """
    else if state == 'SHOOTING'
      """
        <span>Smile! :)</span>
      """
    else if state == 'PAUSED'
      """
        <span>
          <span class='autoshoot-control__normal'>Auto-shoot paused</span>
          <span class='autoshoot-control__hover'>Resume</span>
        </span>
      """
    else if state == 'WAITING_PERMISSIONS'
      """
        <span>Waiting for the camera...</span>
      """

    stateClass =
      if state == 'COUNTDOWN'                then ""
      else if state == 'SHOOTING'            then "is-shooting"
      else if state == 'PAUSED'              then "is-paused"
      else if state == 'WAITING_PERMISSIONS' then ""

    @$dom.empty()
      .html(template)
      .removeClass()
      .addClass("#{@initialClass} #{stateClass}")

  setRemainingSeconds: (seconds) ->
    @remainingSeconds = seconds
    @setState(@state)

