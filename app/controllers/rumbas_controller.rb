# app/controllers/rumbas_controller.rb
class RumbasController < ApplicationController
  include WashOut::SOAP

  # Simple case
  soap_action "integer_to_string",
              :args   => :integer,
              :return => :string
  def integer_to_string
    render :soap => params[:value].to_s
  end

  soap_action "concat",
              :args   => { :a => :string, :b => :string },
              :return => :string
  def concat
    render :soap => (params[:a] + params[:b])
  end

  # Complex structures
  soap_action "AddCircle",
              :args   => { :circle => { :center => { :x => :integer,
                                                     :y => :integer },
                                        :radius => :double } },
              :return => nil, 
              :to     => :add_circle
  def add_circle
    circle = params[:circle]

    raise SOAPError, "radius is too small" if circle[:radius] < 3.0

    Circle.new(circle[:center][:x], circle[:center][:y], circle[:radius])

    render :soap => nil
  end

  # Arrays
  soap_action "integers_to_boolean",
              :args => { :data => [:integer] },
              :return => [:boolean]
  def integers_to_boolean
    render :soap => params[:data].map{|x| x ? 1 : 0}
  end

  # You can use all Rails features like filtering, too. A SOAP controller
  # is just like a normal controller with a special routing.
  before_filter :dump_parameters
  def dump_parameters
    Rails.logger.debug params.inspect
  end
end
