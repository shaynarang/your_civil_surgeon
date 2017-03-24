require 'active_admin/helpers/collection'

module ActiveAdmin
  module Views
    module Pages
      class Index < Base
        protected
        def render_blank_slate
          # this renders the content 'There are no #{model_name.pluralize} yet. Create one.'
          # let's omit it for the time being
          # blank_slate_content = I18n.t("active_admin.blank_slate.content", resource_name: active_admin_config.plural_resource_label)
          # insert_tag(view_factory.blank_slate, blank_slate_content)
        end
      end
    end
  end
end