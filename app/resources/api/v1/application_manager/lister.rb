module Api::V1::ApplicationManager
  class Lister
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 20

    def build
      filter
    end

    private

    def filter
      raise NotImplementedError
    end

    def page=(page)
      @page = page.to_i
      @page = DEFAULT_PAGE if @page.zero?
    end

    def per_page=(per_page)
      @per_page = per_page.to_i
      @per_page = DEFAULT_PER_PAGE if @per_page.zero?
    end

    def initialize(page, per_page, filters = {}, bot_request = false)
      self.page = page
      self.per_page = per_page
      @bot_request = bot_request
      @filters = filters
    end
  end
end
