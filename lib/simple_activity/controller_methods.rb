module SimpleActivity

  # Public: To be used on controller. The module is supposed to be
  # included in ActionController::Base

  module ControllerMethods

    def self.included(base)
      base.after_filter :record_activity, only: [:create, :update, :destroy]
    end

    # The main method to log activity.
    #
    # By default it is used as an after_filter
    #
    # If after_filter disabled, it can be called without arguments
    #
    #   # ArticlesController
    #   def create
    #     @article = Article.create(params[:article])
    #     if @article.save
    #       record_activity
    #     end
    #   end
    #
    # target argument is needed if the instance is not the convention
    # (the sigularize of controller name)
    #
    #   # ArticlesController
    #   def create
    #     @article_in_other_name = Article.create(params[:article])
    #     if @article_in_other_name.save
    #       record_activity(@article_in_other_name)
    #     end
    #   end
    #
    #
    # @param target [Object] the target instance variable. If nil, the processor
    #        will build it according to mathcing instance variable in controller
    #        automatically
    def record_activity(target=nil)
      activity = ::SimpleActivity::ActivityProcessor.new(self, target)
      activity.save
    end

  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include SimpleActivity::ControllerMethods
  end
end