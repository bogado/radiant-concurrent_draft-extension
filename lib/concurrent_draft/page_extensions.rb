module ConcurrentDraft::PageExtensions
  
  def self.included(base)
    base.class_eval do
      alias_method_chain :parse_object, :drafts
    end
  end
  
  def promote_draft!
    parts.reload.each(&:promote_draft!)
    update_attribute('status_id', Status[:published].id)
    super
  end
  
  def unpublish!
    parts.each(&:unpublish!)
    update_attributes('published_at' => nil, 'status_id' => Status[:draft].id)
    super
  end

  def needs_promotion?
    parts.each do |part|
      if part.needs_promotion? then
        return true
      end

	  return false
    end
  end
end
  
  private
  
  def parse_object_with_drafts(object)
    object.content = object.draft_content unless published?
    parse_object_without_drafts(object)
  end
  
end
