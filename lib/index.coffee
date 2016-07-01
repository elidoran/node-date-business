
# number of days to move based on forward/backward and which day of the week
dxs =
  #      Su  M  Tu   W  Th   F  Sa
  '-1': [ -2, -3, -1, -1, -1, -1, -1 ]
  '1' : [  1,  1,  1,  1,  1,  3,  2 ]

class Biz

  constructor: (options) ->
    @holidays = options?.holidays

  isBusinessDay: (options) ->

    date =
      if options instanceof Date then options
      else options.date

    switch date.getDay()

      # weekend, so it's not a business day
      when 0, 6 then return false

      # weekday *could* be a business day, if it's not a holiday
      when 1,2,3,4,5
        # try to get `holidays` from options, then from instance
        # then check if it's a holiday, but eat nulls in case
        # no `holidays` was set anywhere
        holidays = options?.holidays ? @holidays
        if holidays?.isHoliday? date then return false

        # non-holiday weekday is a business day
        return true


  nextBusinessDay    : (date) -> @addBusinessDays date, 1
  previousBusinessDay: (date) -> @addBusinessDays date, -1

  # valid calls:
  #  addBusinessDays date, 1  # standard two args
  #  addBusinessDays date     # defaults days=1
  #  addBusinessDays date:date, days:1  # the options object way
  #  addBusinessDays {days:1}, date     # the currying friendly way
  addBusinessDays: (arg1, arg2) ->

    date = # try getting the date as an arg or from an options object
      if arg1 instanceof Date then arg1
      else if arg2 instanceof Date then arg2
      else arg1?.date ? arg2?.date

    days = # from a number arg, an options object, or defaults to 1
      if typeof arg2 is 'number' then days = arg2
      else if typeof arg1 is 'number' then days = arg1
      else arg1?.days ? arg2?.days ? 1

    # shortcut if we're not changing
    if days is 0 then return

    # determine if we're moving forward or backward
    dx = if days > -1 then 1 else -1

    # get positive number of business days we want to move
    days = Math.abs days

    # look in both args and the instance for a `holidays` instance
    holidays = arg1?.holidays ? arg2?.holidays ? @holidays

    # now, move one day at a time, if it's a business day, decrement our count
    # by one, check if we've moved far enough or we keep going.
    # Note: We must check each weekday because holidays don't count.

    while days > 0
      # move date based on forward/backward and day of the week
      date.setDate date.getDate() + dxs[dx][date.getDay()]

      # if a weekday (1-5) and not a holiday then decrement days
      # if 0 < date.getDay() < 6 and not holidays?.isHoliday(date) then days--
      unless holidays?.isHoliday(date) then days--

    return date


module.exports = (options) -> new Biz options
exports.Biz = Biz
