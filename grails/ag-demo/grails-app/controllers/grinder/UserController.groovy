package grinder

import grails.converters.JSON
import grails.plugin.dao.DomainException
import org.joda.time.DateTime
import org.joda.time.LocalDate

import java.text.SimpleDateFormat

class UserController extends RestDaoController {
  UserController() {
    super(User)
  }
    static final int SC_UNPROCESSABLE_ENTITY = 422

    def selectFields = ["*", "contact.*"]

    protected def listCriteria() {
        def pager = new Pager(params)
        def crit = domainClass.createCriteria()

        def filters = params.filters ? JSON.parse(params.filters) : null
        def qslike = (filters?.quickSearch) ? (filters?.quickSearch + "%") : null

        def datalist = crit.list(max: pager.max, offset: pager.offset) {
            createAlias("contact", "contact")

            if (qslike) {
                or {
                    ilike 'login', qslike
                    ilike 'contact.lastName', qslike
                    ilike 'contact.firstName', qslike
                    ilike 'contact.email', qslike
                }
            }
            if (filters?.org) {
                'in' ('contact.org.id', filters.org.collect { it.id as Long })
            }

            def fcontact = filters?.contact
            if (fcontact?.name) {
                or {
                    ilike 'contact.lastName', fcontact.name
                    ilike 'contact.firstName', fcontact.name
                }
            }
            if (fcontact?.email)
                ilike 'contact.email', fcontact.email

            if (fcontact?.type) {
                def contactTypes = fcontact.type.collect {
                    ContactType.byName(it.id)
                }

                'in' 'contact.type', contactTypes
            }

            if (filters?.login)
                ilike 'login', filters.login

            if (params.sort)
                order(params.sort, params.order)
        }

        return datalist
    }

    // TODO serve it as static asset
    def formTemplate() {
        render(template: "form")
    }

    // TODO serve it as static asset
    def searchPartial() {
        def user = new User()
        render(template: "search", model: [user: user])
    }

}
