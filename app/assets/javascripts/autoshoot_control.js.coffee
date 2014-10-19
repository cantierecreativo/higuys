#= require ./event_emitter

class @AutoshootControl extends EventEmitter
  constructor: (@$dom) ->
    super
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
          <span class='autoshoot-control__normal'>Pause auto-shoot</span>
          <span class='autoshoot-control__hover'>Resume</span>
        </span>
      """
    else if state == 'WAITING_PERMISSIONS'
      """
        <span>Waiting for the camera...</span>
      """

    @$dom.empty().html(template)

  setRemainingSeconds: (seconds) ->
    @remainingSeconds = seconds
    @setState(@state)

