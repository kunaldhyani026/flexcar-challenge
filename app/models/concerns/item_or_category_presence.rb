module ItemOrCategoryPresence
  extend ActiveSupport::Concern

  included do
    validate :item_or_category_presence
  end

  private

  def item_or_category_presence
    unless item.present? || category.present?
      errors.add(:base, 'Either item or category must be present')
    end
  end
end

