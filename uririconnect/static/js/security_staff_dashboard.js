document.getElementById("incident-form").addEventListener("submit", function(event) {
    event.preventDefault();
    var incidentDetails = document.getElementById("incident-details").value;
    // Logic to handle incident report submission goes here
    console.log("Incident Details: " + incidentDetails);
});
