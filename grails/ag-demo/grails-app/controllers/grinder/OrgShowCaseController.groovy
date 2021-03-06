package grinder

import grails.converters.JSON
import org.joda.time.DateTime
import org.joda.time.LocalDate

class OrgShowCaseController extends BaseDomainController {
    def domainClass = OrgShowCase
    def ajaxGrid = true

    def selectFields = ["*"]

    def index() {}

    def get() {
        def org = domainClass.get(params.id)
        if (org) {
            render ExportUtil.buildMapFromPaths(org, selectFields) as JSON
        } else {
            notFound params.id
        }
    }

    def formTemplate() {
        render(template: "form")
    }

    def searchPartial() {
        def orgShowCase = new OrgShowCase()
        render(template: "search", model: [orgShowCase: orgShowCase])
    }

    protected def listCriteria() {
        def pager = new Pager(params)
        def crit = domainClass.createCriteria()

        def filters = params.filters ? JSON.parse(params.filters) : null
        def qslike = (filters?.quickSearch) ? (filters?.quickSearch + "%") : null

        def datalist = crit.list(max: pager.max, offset: pager.offset) {

            if (filters?.name)
                ilike 'name', filters.name

            if (filters?.exampleDate?.from) {
                def from = DateUtil.parseJsonDate(filters.exampleDate.from)
                gt 'exampleDate', from
            }

            if (filters?.exampleDate?.to) {
                def to = DateUtil.parseJsonDate(filters.exampleDate.to)
                lt 'exampleDate', to
            }

            if (filters?.exampleLocalDate?.from) {
                def from = new LocalDate(filters.exampleLocalDate.from)
                gt 'exampleLocalDate', from
            }

            if (filters?.exampleLocalDate?.to) {
                def to = new LocalDate(filters.exampleLocalDate.to)
                lt 'exampleLocalDate', to
            }

            if (filters?.exampleDatetime?.from) {
                def from = new DateTime(filters.exampleDatetime.from)
                gt 'exampleDatetime', from
            }

            if (filters?.exampleDatetime?.to) {
                def to = new DateTime(filters.exampleDatetime.to)
                lt 'exampleDatetime', to
            }

            if (params.sort)
                order(params.sort, params.order)
        }

        return datalist
    }

}
