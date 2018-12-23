# MyBanner - Ruby

Use this program to generate Google Calendar events and/or Google Sheet gradebook files for all your scheduled classes. Uses schedule info from your school's [Ellucian Banner](https://www.ellucian.com/solutions/ellucian-banner) information system.

[![Build Status](https://travis-ci.com/prof-rossetti/my-banner-rb.svg?branch=master)](https://travis-ci.com/prof-rossetti/my-banner-rb)
[![Maintainability](https://api.codeclimate.com/v1/badges/41968ec227c9b165cd82/maintainability)](https://codeclimate.com/github/prof-rossetti/my-banner-rb/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/41968ec227c9b165cd82/test_coverage)](https://codeclimate.com/github/prof-rossetti/my-banner-rb/test_coverage)

## Prerequisites

This is a Ruby program which requires Ruby (version 2.5) and Bundler (version 1.16) as dependencies.

## Installation

To install the program, download or clone it [from GitHub](https://github.com/prof-rossetti/my-banner-rb):

```sh
git clone git@github.com:prof-rossetti/my-banner-rb.git
```

All subsequent usage commands assume you will be running them from the root directory of this repository, so navigate there now:

```sh
cd my-banner-rb/
```

## Setup

Install the program's Ruby package dependencies by running the setup script:

```sh
bin/setup
```

## Usage

Before the program can generate Google Calendar events and/or Google Sheet gradebook files for all your scheduled classes, it needs access to your schedule. So follow the section below to [Download Schedule Page from Banner](#download-schedule-page-from-banner) before performing any of the other functionality.

### Download Schedule Page from Banner

To access your schedule of classes for some specified term, login to banner site (e.g. https://myaccess.georgetown.edu/), and navigate to: **Home > Faculty Services > Faculty Detail Schedule**.

Then download your schedule page as an HTML file and move it into this repo at: **pages/faculty-detail-schedule.html**.

To check the program's ability to parse that HTML content, run the schedule parser script and inspect its results:

```sh
bundle exec rake parse_schedule
```

As long as the schedule data looks like it reflects the contents you saw on your schedule page, you are ready to use this program to [Generate Google Calendar Events](#Generate-Google-Calendar-Events) and/or [Generate Google Sheet Gradebook Files](#Generate-Google-Sheet-Gradebook-Files).

### Generate Google Calendar Events

For the program to issue requests to the Google Calendar API, it needs the credentials of a Google APIs client application that has access to the Google Calendar API. From the [Google Calendar API quickstart guide](https://developers.google.com/calendar/quickstart/ruby), click "Enable the Calendar API" and follow the instructions to create a new app and generate new credentials. Download the resulting credentials file and move it into this repo at: **auth/calendar_credentials.json**.

Once the schedule page and calendar credentials are in place, you can create google calendars and events for your scheduled classes by running the calendar creation script:

```sh
bundle exec rake create_calendars
```

When running this command for the first time, you will be prompted to login to Google to get an authorization code. After supplying that code to this program, the program will store an access token which will be used to authorize subsequent requests on your behalf, so you don't need to login again.

### Generate Google Sheet Gradebook Files

For the program to manage your google sheets, it needs to use both the sheets and drive apis.

For the program to issue requests to the Google Sheets API, it needs the credentials of a Google APIs client application that has access to the Google Sheets API. From the [Google Sheets API quickstart guide](https://developers.google.com/sheets/api/quickstart/ruby), click "Enable the Sheets API" and follow the instructions to create a new app or select an existing one, and generate new credentials. Download the resulting credentials file and move it into this repo at: **auth/spreadsheet_credentials.json**.

For the program to issue requests to the Google Drive API, it needs the credentials of a Google APIs client application that has access to the Google Drive API. From the [Google Drive API quickstart guide](https://developers.google.com/drive/api/v3/quickstart/ruby), click "Enable the Sheets API" and follow the instructions to create a new app or select an existing one, and generate new credentials. Download the resulting credentials file and move it into this repo at: **auth/drive_credentials.json**.

Once the schedule page and spreadsheet credentials and drive credentials are in place, you can create google sheet gradebooks for your scheduled classes by running the spreadsheet creation script:

```sh
bundle exec rake create_spreadsheets
```

When running this command for the first time, you will be prompted to login to Google to get an authorization codes for both the sheets and drive apis, respectively. After supplying each code to this program, the program will store an access token which will be used to authorize subsequent requests on your behalf, so you don't need to login again.

## [Contributing](/CONTRIBUTING.md)

## [License](/LICENSE.md)
