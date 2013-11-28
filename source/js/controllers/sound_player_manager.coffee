App.SoundPlayerManager = Ember.StateManager.extend
  initialState: "initializing"
  states:
    initializing: Ember.State.create()
    waiting: Ember.State.create()
    playing: Ember.State.create()
    paused: Ember.State.create()
