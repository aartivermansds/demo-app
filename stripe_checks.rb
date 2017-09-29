require 'stripe'

Stripe.api_key = "sk_test_NBc7XOC47kj0VLzLJxSOmJZp"

Stripe::Charge.create(

    :amount => 2000,
    :currency => "USD",
    :description => "Charge for ravi.singh1308@mailinator.com"

)


customer = Stripe::Customer.create(email: "ravi@mailinator.com", source: "tok_1B5rDgA1dRl2LsGMzgz2gZ5z")