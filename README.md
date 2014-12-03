# Slotr

Slotr is an application that helps secretaries coordinate interviews between him/herself, an interviewee, and several interviewers.

## In Development

[Wireframe](https://www.fluidui.com/editor/live/preview/p_h3OtaxhUAKGXED1OH7ZCr2m8WThRQgv3.1417585944460)
[Huboard](https://huboard.com/danielchangNYC/slotr)
[Github](https://github.com/danielchangNYC/slotr)

## Setup

### config/secrets.yml

You will need to create a new application in the Google API Console.

Be sure to turn on the Google+, Calendar, and Contact APIs at minimum.

Finally, create your secrets.yml file.

Example `config/secrets.yml` file:
```
development:
  secret_key_base: 5db5ab78fa8dad3492bf7386b7cfbeda091767508860b87a81a7126c98f57289243822d7cc359cc596d03f83fcc1d5c65864efbabd65fb1b9472fb79d2f5538a
  APP_ID: your-google-client-id
  APP_SECRET: your-google-client-secret

test:
  secret_key_base: 9c1afe283b2ec1a644258f5b79e3c1a0da0a453d95ce375714bb349699f1028ad0955a0d13370025c6f9daaf4eb11a93f33ae979a365b12b43280b39f25b1bae
```
