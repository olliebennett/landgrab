# Checkout

The checkout process involves buying a subscription.

Checkout is possible via two methods; internal or external.

## Internal Checkout

This relies on the user being authenticated in the Landgrab app;
they go to view any tile and can click the "subscribe" button
to subscribe to that tile.

We'll set up a Stripe checkout session associated to the tile,
and redirect the user to Stripe to complete the payment.

After an internal checkout completes, the user is returned to
the Landgrab app (`checkout_success_path`) and the subscription is completed,
and associated to the user and corresponding tile.

## External Checkout

This works by sending a (likely unauthenticated) user to one of
the following (`checkout_generate_path`) endpoints;

```
/checkout/generate?freq=monthly
/checkout/generate?freq=yearly
```

This endpoint will generate a Stripe checkout, associating it to the
user if they are logged in, and redirect the customer to complete
payment through Stripe.

After completing the payment, the user will reach a 'claim' page
(`checkout_claim_path`) which is a dead end. We'll separately receive
a webhook informing us of the subscription, and will send an email
to the email provided during the Stripe checkout through which the
recipient can claim the subscription.
