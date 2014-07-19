$.get '/history/tracks', (placemark) =>
  data = placemark.Placemark['gx:Track']

  coords = _.map data['gx:coord'], (val, idx) ->
    _.initial(_.map val.split(' '), parseFloat).reverse()

  times = data.when

  office = $ll [33.7791558,-84.40921]
  outerpt = $ll [33.7778323,-84.4073616]

  fence =
    center: office
    range: office.distance_to_miles outerpt

  @hist = _.object times, _.pairs(_.object times, coords)

  @groups =
    working: false,
    entries: []

  _.each @hist, (track) =>
    t = Date.create(track[0]).format()
    c = track[1]

    dist = $ll(c).distance_to_miles(fence.center)

    if dist <= fence.range and @groups.working == false
      @groups.working = true
      @groups.entries.push {start: t}
      return

    if dist > fence.range and @groups.working == true
      @groups.working = false
      (_.last @groups.entries).end = t
      return

  report = (
    _.map groups.entries, (entry) ->
      day = Date.create(entry.start).format('{MM}/{dd}')
      startTime = Date.create(entry.start).format('{12hr}:{mm}:{ss} {tt}')
      endTime = Date.create(entry.end).format('{12hr}:{mm}:{ss} {tt}')
      return "<tr><td>#{day}</td><td>#{startTime}</td><td>#{endTime}</td></tr>"
  )

  $('#hours tbody').html(report)


