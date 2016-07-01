# @date/business
[![Build Status](https://travis-ci.org/elidoran/node-date-business.svg?branch=master)](https://travis-ci.org/elidoran/node-date-business)
[![Dependency Status](https://gemnasium.com/elidoran/node-date-business.png)](https://gemnasium.com/elidoran/node-date-business)
[![npm version](https://badge.fury.io/js/%40date%2Fbusiness.svg)](http://badge.fury.io/js/%40date%2Fbusiness)

Calculate business day dates optionally considering holidays.

See [@date/holidays](http://github.com/elidoran/node-date-holidays)

## Install

```sh
npm install @date/business --save
```

## Usage

```javascript
// use @date/holidays instance when calculating business days
// it's optional. don't set a holidays instance and it only considers Mon-Fri
var biz = require('@date/business')({
  holidays: require('@date/holidays-us')
})

// New Year's Day 2016 is a Friday, a holiday
var date = new Date(2016, 0, 1)
biz.isBusinessDay(date) // false, it's a holiday

// nextBusinessDay() will change it to
// Monday, the 4th, after New Year's (Friday), which is a business day
biz.nextBusinessDay(date)
biz.isBusinessDay(date) // true

// move it to Wednesday
biz.addBusinessDays(date, 2)
biz.isBusinessDay(date) // true

// move it to the next Monday, it skips both Saturday and Sunday
biz.addBusinessDays(date, 3)
biz.isBusinessDay(date) // true

// 5 business days would be the next Monday, which is
// Martin Luther King Jr. Day, so, it'll end up being Tuesday instead
biz.addBusinessDays(date, 5)
biz.isBusinessDay(date) // true

// back up to the holiday
date.setDate(date.getDate() - 1)
biz.isBusinessDay(date) // false

// previous business day is the Friday
biz.previousBusinessDay(date)
// OR:
// biz.addBusinessDays date, -1
biz.isBusinessDay(date) // true

```

## MIT License
