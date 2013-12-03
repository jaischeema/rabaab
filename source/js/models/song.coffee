App.Song = Em.Object.extend
  normal_quality_url: null
  isPlayable: Ember.computed.bool('normal_quality_url')
  musicURL: Ember.computed.oneWay('normal_quality_url')
  refresh: ->
    id = @get('id')
    Ember.$.getJSON("#{App.squirrel_url}/song?id=#{id}").then (data) =>
      @setProperties(data)

