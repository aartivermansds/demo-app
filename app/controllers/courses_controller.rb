class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json

  respond_to :js

  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
   @course = Course.find(params[:id])
  end
  
  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        stripe = StripeIntegrationClass.new
        product = stripe.create_stripe_product(@course.name, @course.course_fee)
        @course.update(stripe_product_id: product.id )
        puts product
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        stripe = StripeIntegrationClass.new
        pr = stripe.update_stripe_product(@course.stripe_product_id, @course.name)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    stripe = StripeIntegrationClass.new
    stripe.destroy_stripe_product(@course.stripe_product_id)
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def new_course_enrollment
    @course = Course.find(params[:course_id])
    respond_to do |format| 
      format.js {'courses/new_course_enrollment'}
    end
  end

  def create_course_enrollment
    @enrollment = CourseRegistration.new(enrollment_params)
    @enrollment.save
    @enrollment.update_attributes(:stripe_token => params[:stripeToken], :stripe_token_type => params[:stripeTokenType], :email => params[:stripeEmail])
    stripe = StripeIntegrationClass.new
    customer = stripe.create_stripe_customer(params[:stripeToken],params[:stripeEmail])
    c = stripe.retrieve_customer_stripe(customer.id)
    cu = stripe.list_customer_stripe()
    Customer.create(stripe_customer_email: customer.email, stripe_customer_id: customer.id)
    puts c
  redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :course_fee)
    end

    def enrollment_params
      params.require(:create_course_enrollment).permit(:first_name, :last_name, :contact, :course_id)
    end
end
