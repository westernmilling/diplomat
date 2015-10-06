module Interface
  module IRely
    module Location
      class Parse < Interface::IRely::Parse
        def call
          parse unless no_data?

          self
        end
      end
    end
  end
end
