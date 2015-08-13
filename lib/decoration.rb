module Decoration
  refine Array do
    def decorate_all
      dup.map(&:decorate)
    end
  end
end
