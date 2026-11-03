The following user stories describe the Search functionality of the Air Canada website, focusing on four specific interactions: selecting an airport from the suggested locations, selecting departure and return dates, clicking the Search button, and selecting a flight from the search results. Any other interactions, such as typing an airport name or completing a booking, are outside the scope of this assignment.
All user stories follow the template: As a [role], I want [goal/desire] so that [benefit]. Acceptance criteria describe the expected observable behavior of the system, including successful outcomes and exceptional cases.
User Story 1 – Search for Flights <<epic>>
As a traveler, I want to search for flights based on my travel preferences so that I can find flights that meet my travel needs.
User Story 1.1 – Select Departure and Destination Airports
As a traveler, I want to select my departure and destination airports from the suggested locations so that I can make sure I am searching for flights between the correct places.
Acceptance Criteria (Verify that):
1.1.1. When the user selects a suggested departure airport, the system saves it as the departure location.
1.1.2. When the user selects a suggested destination airport, the system saves it as the arrival location.
1.1.3. The system displays the name and airport code of the selected airport.
1.1.4. When the user selects an airport, the system clearly identifies the selected airport so that it is not confused with another airport in the same city.
1.1.5. When the user selects a different airport, the system replaces the previous selection with the new one.
1.1.6. Once an airport is selected, the system keeps the selected location unless the user changes it.
User Story 1.2 – Select Travel Dates
As a traveler, I want to select my departure and return dates so that I can search for flights during my planned travel period.
Acceptance Criteria (Verify that):
1.2.1. When the user requests to select a departure date, the system provides available dates for selection.
1.2.2. When the user requests to select a return date, the system provides available return dates for selection.
1.2.3. The system clearly identifies the month and year of the dates being displayed.
1.2.4. The system does not allow the user to select a departure date in the past.
1.2.5. When the user selects a valid departure date, the system saves it as the departure date.
1.2.6. When the user selects a valid return date, the system saves it as the return date.
1.2.7. The system does not accept a return date that is earlier than the departure date.
1.2.8. If the user changes a previously selected date, the system updates the corresponding travel date.
1.2.9. For a round-trip search, when the user selects a departure date without a valid return date, the system informs the user that a return date is required.
User Story 1.3 – Find Available Flights
As a traveler, I want to search for available flights based on my selected travel information so that I can compare different flight options for my trip.
Acceptance Criteria (Verify that):
1.3.1. When the user submits a search with valid information, the system provides flights matching the selected departure airport, destination airport, and travel dates.
1.3.2. If a required departure or destination airport is missing, the system informs the user that the missing information must be provided.
1.3.3. If a required travel date is missing, the system informs the user that a date must be selected before searching.
1.3.4. If the selected departure and destination airports are the same, the system informs the user that the search is invalid.
1.3.5. If the return date is before the departure date, the system prevents the search and informs the user that the dates are invalid.
1.3.6. When flights are available, the system provides the departure and arrival times, travel duration, and price for each flight option.
1.3.7. The system indicates whether the available flights are direct or include connections.
1.3.8. For a round-trip search, the system provides flight options for the requested outbound and return journeys.
1.3.9. If no flights match the search information, the system informs the user that no matching flights were found.
1.3.10. If the search cannot be completed because of a system error, the system informs the user that the search was unsuccessful rather than displaying incorrect results.
User Story 2 – Compare Fare Options for a Selected Flight
As a traveler, I want to compare the available fares for a selected flight so that I can choose an option that fits my budget and travel needs.
Acceptance Criteria (Verify that):
2.1. When the user selects a flight from the search results, the system provides the available fare options for that flight.
2.2. The system identifies the fare type associated with each available option.
2.3. The system displays the price associated with each available fare option.
2.4. The system provides information about the baggage allowance included with each fare option.
2.5. The system indicates whether changes or cancellations are allowed for each fare option and whether additional fees apply.
2.6. The system provides information about the seat selection conditions associated with each fare option.
2.7. The system provides information about the applicable Aeroplan rewards for each fare option.
2.8. The system allows the traveler to distinguish between the benefits and restrictions of the available fare options.
2.9. The system only presents fare options associated with the selected flight.
2.10. If a fare option is unavailable, the system does not present it as available for selection.
