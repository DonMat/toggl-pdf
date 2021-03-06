Report = require './report'
moment = require 'moment'

class WeeklyReport extends Report
  constructor: (@data) ->
    @LEFT = 35
    @DESCRIPTION_WIDTH = 200
    super @data

  finalize: ->
    @translate 0, 50
    @reportHeader 'Weekly report'

    @translate 0, 75
    @selectedFilters()

    @translate 0, 30
    @reportTable()

    @translate 0, 10
    @createdWith()

  fileName: ->
    "Toggl_#{@data.params?.grouping}_#{@data.params?.since}_to_#{@data.params?.until}"

  reportTable: ->
    @doc.font('FontBold').fontSize(7).fill('#6f7071')
    @doc.text 'Client - project', @LEFT, 1

    day = moment @data.params['since']
    for dayNum in [0...7]
      @doc.text day.format('MMM D'), 250 + dayNum * 40, 1
      day.add 1, 'day'
    @doc.text 'Total', 530, 1, width: 0
    @translate 0, 15

    @doc.fill('#000').strokeColor('#dde7f7')
    for row in @data.data
      @doc.font 'FontBold'
      @drawRow row
      for subRow in row.details
        @doc.font 'FontRegular'
        @drawRow subRow

  rowTitle: (row) ->
    names = []
    names.push row.user if row.user?
    names.push row.client if row.client?
    names.push row.project if row.project?
    names.push '(no project)' if names.length < 1
    names.join ' - '

  slotDuration: (seconds) ->
    if seconds > 0
      @displayDuration(seconds)
    else
      ""

  showEarnings: ->
    @data.params.calculate? && @data.params.calculate == 'earnings'


  slotEarnings: (amount, currency) ->
    if amount?
      amount + ' ' + currency
    else
      ""

  drawCells: (slot, idx) ->
    if @showEarnings()
      for amount, i in slot.amount
        @doc.text @slotEarnings(amount, slot.currency), 250 + i * 40, 1, width: 0
    else
      @doc.text @slotDuration(slot), 250 + idx * 40, 1, width: 0

  drawRow: (row) ->
    description = @rowTitle(row.title)
    lineCount = Math.ceil(description.length / 46)
    @doc.text description, @LEFT, 1, width: @DESCRIPTION_WIDTH
    for slot, i in row.totals
       @drawCells(slot, i)
    @translate 0, lineCount * 15
    if @posY > Report.PAGE_HEIGHT - Report.MARGIN_BOTTOM
      @addPage()
      @translate 0, 30

module.exports =  WeeklyReport
