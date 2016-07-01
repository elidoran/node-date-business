assert = require 'assert'
biz    = require('../../lib') holidays:require('@date/holidays-us')

tests =

  isBusinessDay: [

    {
      date: new Date 2016, 5, 26
      result: false
      description: 'a Sunday'
    }

    {
      date: new Date 2016, 5, 27
      result: true
      description: 'a Monday'
    }

    {
      date: new Date 2016, 5, 28
      result: true
      description: 'a Tuesday'
    }

    {
      date: new Date 2016, 5, 29
      result: true
      description: 'a Wednesday'
    }

    {
      date: new Date 2016, 5, 30
      result: true
      description: 'a Thursday'
    }

    {
      date: new Date 2016, 6, 1
      result: true
      description: 'a Friday'
    }

    {
      date: new Date 2016, 6, 2
      result: false
      description: 'a Saturday'
    }

    { # a bank holiday on a Friday
      date: new Date 2016, 0, 1
      result: false
      description: 'New Year\'s Day of 2016'
    }

    { # a bank holiday on a Thursday
      date: new Date 2016, 10, 24
      result: false
      description: 'Thanksgiving Day of 2016'
    }

  ]

  nextBusinessDay: [
    { # a Thursday with a bank holiday the next day
      date: new Date 2015, 11, 31
      options: bank:true
      result: new Date 2016, 0, 4
      resultString: 'Monday, January 4th 2016'
      description: 'New Year\'s Eve of 2015'
    }

    { # a bank holiday and next day is Saturday
      date: new Date 2016, 0, 1
      options: bank:true
      result: new Date 2016, 0, 4
      resultString: 'Monday, January 4th 2016'
      description: 'New Year\'s Day of 2016'
    }

    { # a Saturday
      date: new Date 2016, 0, 2
      options: bank:true
      result: new Date 2016, 0, 4
      resultString: 'Monday, January 4th 2016'
      description: 'Saturday after New Year\'s of 2016'
    }

    { # a Sunday
      date: new Date 2016, 0, 3
      options: bank:true
      result: new Date 2016, 0, 4
      resultString: 'Monday, January 4th 2016'
      description: 'Sunday after New Year\'s of 2016'
    }

    { # a Monday
      date: new Date 2016, 0, 4
      options: bank:true
      result: new Date 2016, 0, 5
      resultString: 'Tuesday, January 5th 2016'
      description: 'A non-holiday Monday'
    }
  ]

  previousBusinessDay: [
    { # a Thursday with a non-holiday weekday the previous day
      date: new Date 2015, 11, 31
      options: bank:true
      result: new Date 2015, 11, 30
      resultString: 'Wednesday, December 30th 2015'
      description: 'New Year\'s Eve of 2015'
    }

    { # a bank holiday and previous day is Thursday
      date: new Date 2016, 0, 1
      options: bank:true
      result: new Date 2015, 11, 31
      resultString: 'Thursday, December 31st 2015'
      description: 'New Year\'s Day of 2016'
    }

    { # a Saturday and previous day is New Year's bank holiday
      date: new Date 2016, 0, 2
      options: bank:true
      result: new Date 2015, 11, 31
      resultString: 'Thursday, December 31st 2015'
      description: 'Saturday after New Year\'s of 2016'
    }

    { # a Sunday and previous biz day, Friday, is New Year's, a bank holiday
      date: new Date 2016, 0, 3
      options: bank:true
      result: new Date 2015, 11, 31
      resultString: 'Thursday, December 31st 2015'
      description: 'Sunday after New Year\'s of 2016'
    }

    { # a Monday and previous biz day, Friday, is New Year's, a bank holiday
      date: new Date 2016, 0, 4
      options: bank:true
      result: new Date 2015, 11, 31
      resultString: 'Thursday, December 31st 2015'
      description: 'Monday after New Year\'s (Friday) of 2016'
    }
  ]

describe 'test biz', ->

  for name, array of tests

    do (name, array) ->

      describe name + '()', ->

        for test in array

          do (test) ->

            it "should return #{test.resultString ? test.result} when it's #{test.description}", ->

              date = test.date
              if typeof date is 'function' then date = date()

              arg = test.options ? date
              if test.options? then arg.date = test.date

              result = biz[name] arg

              if test.result instanceof Date
                assert.equal test.result.getTime(), result.getTime()
              else
                assert.equal test.result, result
