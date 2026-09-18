const SUPABASE_URL = https://uehpvsbbcyrjjndektzx.supabase.co/rest/v1/
const SUPABASE_KEY = 
sb_publishable_iW-7tEiyWD6FbV1Vv99DEg_wON3fLjN
const supabaseClient = supabase.createClient(
    SUPABASE_URL,
    SUPABASE_KEY
);

async function showEvents() {
    const eventList = document.getElementById("event-list");

    eventList.innerHTML = "Loading events...";

    const { data, error } = await supabaseClient
        .from("events")
        .select("*")
        .eq("status", "upcoming")
        .order("event_date", { ascending: true });

    if (error) {
    console.error(error);
    eventList.innerHTML =
        "Database error: " + error.message;
    return;
    }

    if (!data || data.length === 0) {
        eventList.innerHTML = "No upcoming events yet.";
        return;
    }

    eventList.innerHTML = "";

    data.forEach(event => {
        const card = document.createElement("div");

        card.innerHTML = `
            <h3>${event.event_name}</h3>
            <p>${event.event_type}</p>
            <p>${event.event_date}</p>
            <p>${event.description || ""}</p>
        `;

        eventList.appendChild(card);
    });
}

showEvents();
