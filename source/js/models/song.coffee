App.Song = Em.Object.extend
  normal_quality_url: null
  isPlayable: Ember.computed.bool(App.media_url_key)
  musicURL: Ember.computed.oneWay(App.media_url_key)
  refresh: ->
    id = @get('id')
    Ember.$.getJSON("#{App.squirrel_url}/song?id=#{id}").then (data) =>
      @setProperties(data)

