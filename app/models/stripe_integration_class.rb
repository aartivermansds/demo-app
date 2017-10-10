class StripeIntegrationClass
    
    require "stripe"
    Stripe.api_key = Rails.application.secrets.stripe_secret_key

    def create_stripe_customer(stripe_token, email)
        customer = Stripe::Customer.create(
            source: stripe_token,
            email: email
        )
    end
    
    def retrieve_customer_stripe(customer_id)
        customer = Stripe::Customer.retrieve(customer_id)    
    end
    
    def list_customer_stripe()
        customer = Stripe::Customer.list
    end
    
    def delete_customer_stripe(customer_id)
        customer = Stripe::Customer.retrieve(customer_id)
        customer.delete    
    end
    
    def update_customer_stripe(customer_id)
        customer = Stripe::Customer.retrieve(customer_id)
        customer.save
    end  
    
    def create_stripe_product(name, description) 
        product = Stripe::Product.create(
            name: name,
            description: description
        )
    end 

    def retrieve_stripe_product(product_id)
        product = Stripe::Product.retrieve(product_id)    
    end
    
    def update_stripe_product(product_id, name)
        product = Stripe::Product.retrieve(product_id)
        product.name = name
        product.save
    end
    
    def destroy_stripe_product(product_id)
        product = Stripe::Product.retrieve(product_id)
        product.delete
    end
end
