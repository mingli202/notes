# Assignment 3 – User Stories

Course: ECSE 326 – Software Requirements Engineering
Term: Fall 2026
Team number: Group 11
Team members: Emilia Bridgeman, Mingli Liu

# User Stories

The following user stories describe the Search functionality of the Air Canada website. They cover only the system's response to four interactions: selecting an airport from the suggested locations, requesting to set the departure or return date, submitting the search, and selecting a flight from the search results. Any other interaction (e.g., typing an airport name, choosing a date, changing the trip type or number of passengers, or completing a booking) is out of scope.

All user stories follow the template:
"As a [role], I want to [desire] so that I can [benefit]"

Acceptance criteria describe the expected observable response of the system, including successful outcomes and exceptional cases.

## User Story 1 – Search for Flights <<epic>>

As a traveller, I want to search for flights that match my trip so that I can choose a flight that fits my travel needs.

Broken down into: User Stories 1.1, 1.2, 1.3 and 1.4.

## User Story 1.1 – Select Departure and Arrival Airports

As a traveller, I want to select my departure and arrival airports from the suggested locations so that I can be sure I am searching for flights between the correct places.

Acceptance criteria (verify that):

- 1.1.1. When the traveller selects a suggested location for the departure, the system records it as the departure location.
- 1.1.2. When the traveller selects a suggested location for the arrival, the system records it as the arrival location.
- 1.1.3. After a selection, the system displays the selected location's unique three-letter code and its city, so that two airports serving the same city (e.g., YYZ and YTZ for Toronto) can be told apart.
- 1.1.4. When the traveller selects a suggested city rather than a specific airport, the system records the city as the location, so that all of the city's airports are included in the search.
- 1.1.5. When the traveller selects a suggestion, the system stops presenting the other suggested locations.
- 1.1.6. When the traveller selects the arrival location, the system moves on to the travel dates as the next detail to provide.
- 1.1.7. When the traveller selects a different suggestion for a location that was already chosen, the system replaces the previous selection with the new one.
- 1.1.8. Selecting a departure location does not change the chosen arrival location or travel dates, and selecting an arrival location does not change the chosen departure location or travel dates.
- 1.1.9. When the traveller selects a suggestion for a location that the system had reported as missing or invalid, the system no longer reports that location as an error.

## User Story 1.2 – View Available Travel Dates

As a traveller, I want to view the dates I can choose when I set my departure or return date so that I can plan my travel period before searching for flights.

Acceptance criteria (verify that):

- 1.2.1. When the traveller requests to set the departure date, the system presents the dates of the selectable period and asks the traveller to select a departure date.
- 1.2.2. When the traveller requests to set the return date, the system presents the dates of the selectable period, indicates the chosen departure date, and asks the traveller to select a return date.
- 1.2.3. The system presents the dates grouped by month and identifies the month and year of each group.
- 1.2.4. The system initially presents the month of the chosen departure date or, if no departure date is chosen, the current month.
- 1.2.5. The system indicates the current date.
- 1.2.6. The system presents dates earlier than the day before the current date, and dates beyond the end of the booking period, as unavailable (e.g., on 2 November 2026, 24 October 2027 is available and 25 October 2027 is unavailable).
- 1.2.7. If travel dates are already chosen, the system indicates the chosen departure and return dates, the length of the trip in days, and the lowest round-trip price for those dates when one is available.
- 1.2.8. If fare information is available for the chosen locations, the system indicates for each date how its fare compares with the other dates, from highest to lowest fare; otherwise, no fare comparison is presented.
- 1.2.9. When a fare comparison is presented, the system states its basis: per person, trip type, and currency.

## User Story 1.3 – Find Available Flights

As a traveller, I want to search for available flights using my selected trip details so that I can compare the flight options for my trip.

Acceptance criteria (verify that):

- 1.3.1. If the departure or arrival location is missing or is not a selected location, the system does not perform the search and states which location (point of origin or destination) must be provided.
- 1.3.2. If a required travel date is missing, the system does not perform the search and states that valid travel dates must be provided; if only the return date is missing, it states that a valid return date must be provided.
- 1.3.3. If the departure and arrival locations are the same airport or are in the same city, the system does not perform the search and informs the traveller that they must be different.
- 1.3.4. If the search is not performed, the system keeps all the information already entered and identifies what must be corrected.
- 1.3.5. When the traveller submits a search with valid information, the system presents a summary of the search (locations, trip type, dates and number of passengers) and the outbound flights matching the selected locations and departure date, together with the number of flights found.
- 1.3.6. For each flight, the system provides the departure and arrival times and airports (indicating an arrival on a later day), the number of stops with each connection airport and layover duration, the total travel duration, and the operating carrier when it is not Air Canada.
- 1.3.7. For each flight, the system provides the lowest price for each cabin offered on the route, or indicates that the cabin is unavailable, and identifies the lowest-priced flights and flights with mixed cabins.
- 1.3.8. The system states the currency of the prices and that they are per person, each way, include all taxes, fees and charges and, for a round trip, are based on the purchase of a round-trip ticket.
- 1.3.9. The system presents the lowest fare for each of several days before and after the selected departure date, and indicates the days without available fares.
- 1.3.10. If no flights match the search information, the system informs the traveller that no flights were found, suggests searching other dates, and presents the entered trip details ready to be modified.

## User Story 1.4 – Compare Fare Options for a Selected Flight

As a traveller, I want to compare the available fares for a flight from the search results so that I can choose a fare that fits my budget and travel needs.

Acceptance criteria (verify that):

- 1.4.1. When the traveller selects a flight from the search results in a given cabin, the system provides only the fare options available for that flight in that cabin, each identified by its cabin and fare type.
- 1.4.2. The system displays the price per person of each fare option, ordered from lowest to highest price.
- 1.4.3. The system provides the baggage allowance, seat selection conditions, and any other included services (e.g., lounge access, priority check-in) of each fare option.
- 1.4.4. The system indicates for each fare option whether changes and cancellations are allowed, whether fees apply, and whether the fare is refundable.
- 1.4.5. If a fare option includes flight segments in a lower cabin than the one selected, the system identifies those segments and the cabin provided on each.
- 1.4.6. When a fare option earns loyalty program points and status qualifying credits, the system provides the amounts earned.
- 1.4.7. If few seats remain at a fare, the system indicates the number of seats remaining.
- 1.4.8. If a higher cabin has seats on the selected flight, the system presents it as an upgrade option with its lowest price.
- 1.4.9. If a cabin has no seats available on the selected flight, the system indicates that the cabin is unavailable and provides no fare options for it.
- 1.4.10. The system provides the fare options of only one flight at a time: selecting a different flight replaces them with those of the newly selected flight, and selecting the same flight and cabin again hides them.
