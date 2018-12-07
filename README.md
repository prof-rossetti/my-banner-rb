# MyBanner - Ruby

WIP - Generates Google Calendar Events and Google Sheet Rosters for all your classes.

[![Build Status](https://travis-ci.com/prof-rossetti/my-banner-rb.svg?branch=master)](https://travis-ci.com/prof-rossetti/my-banner-rb)

[![Maintainability](https://api.codeclimate.com/v1/badges/41968ec227c9b165cd82/maintainability)](https://codeclimate.com/github/prof-rossetti/my-banner-rb/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/41968ec227c9b165cd82/test_coverage)](https://codeclimate.com/github/prof-rossetti/my-banner-rb/test_coverage)

## Installation

Clone from source:

```sh
git clone git@github.com:prof-rossetti/my-banner-rb.git
cd my-banner-rb/
```

## Setup

Install package dependencies:

```sh
bin/setup
```

## Configuration

From the [Google Calendar API's quickstart guide](https://developers.google.com/calendar/quickstart/ruby), click "Enable the Calendar API" and follow the instructions to create a new app and generate new credentials. Store the resulting file in this repository as **calendar_auth/credentials.json**.

From a developer console (`bin/console`), for the first time only, invoke `MyBanner::CalendarAuthorization.new.user_provided_credentials` and follow the instructions to get permission to make requests on behalf of some google calendar user. This will generate a **calendar_auth/token.yaml** file and store an access token there. The access token will be used to authorize subsequent requests.

## Usage

### Create Google Calendar Events

1. Login to https://myaccess.georgetown.edu/, then navigate to: **Home > Faculty Services > Faculty Detail Schedule** to access your schedule of classes. Note: you might need to select a term along the way.

2. Once you have accessed your schedule, use your browser to save the HTML page in this repository as: **pages/faculty-detail-schedule.html**.

3. Finally, execute the scheduling program:

```rb
bundle exec rake create_calendars
```

## [Contributing](/CONTRIBUTING.md)

## [License](/LICENSE.md)
