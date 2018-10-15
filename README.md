# MyBanner

Generates Google Calendar schedules and Google Sheet rosters for all your classes.

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

From the [Google Calendar API's quickstart guide](https://developers.google.com/calendar/quickstart/ruby), click "Enable the Calendar API" and follow the instructions to create a new app and generate new credentials. Store the resulting **credentials.json** in the root directory of this repo. From a developer console (`bin/console`), for the first time only, invoke `MyBanner::GoogleCalendarAPI.new.client` to receive a redirect URL, follow the URL to log in with your Google Account, then copy and paste the code back into the development console and press "ENTER". This will generate a **token.yaml** file in the root directory of this repository and store an access token there. The access token will be used to authorize subsequent requests.

## Usage

### Generate Schedule on Google Calendar

1. Login to https://myaccess.georgetown.edu/, then navigate to: **Home > Faculty Services > Faculty Detail Schedule** to access your schedule of classes. Note: you might need to select a term along the way.

2. Once you have accessed your schedule, use your browser to save the HTML page in this repository as: **pages/faculty-detailed-schedule.html**.

3. Finally, execute the scheduling program:

```rb
bundle exec rake schedule_events
```

## [Contributing](/CONTRIBUTING.md)

## [License](/LICENSE.md)
