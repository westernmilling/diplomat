module Interface
  module IRely
    module Entity
      class Translate < Interface::IRely::Translate
        def call
          translate unless @context.nil?

          self
        end

        def translate
          @output.merge!(
            name: @context.root_instance.name,
            entityNo: @context.root_instance.reference,
            contacts: contacts,
            locations: locations,
            customer: customer
          )
            .merge!(id)
        end

        protected

        def contacts
          translate_klass('Contact')
            .translate(@context.child_contexts[:contacts])
        end

        def locations
          translate_klass('Location')
            .translate(@context.child_contexts[:locations])
        end

        def customer
          translate_klass('Customer')
            .translate(@context.child_contexts[:customer])
        end

        def translate_klass(module_translate)
          "::Interface::IRely::#{module_translate}::Translate".constantize
        end
      end
    end
  end
end
