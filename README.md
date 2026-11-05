# Pawna Escape — Company Team Getaway

A responsive, static website proposal for a company getaway to Pawna Lake. It includes:

- The three-day / two-night trip concept and itinerary
- A researched villa shortlist with official property links and images
- A team villa-preference poll
- The Bhayandar → Dadar Western → Dadar Central → Lonavala → Pawna route
- Activity ideas, food planning, logistics and safety notes

The public website intentionally contains no calendar dates or monetary amounts.

## Run locally

Open `index.html` in a browser, or run a simple static server:

```bash
python3 -m http.server 8080
```

Then open `http://localhost:8080`.

Without Supabase credentials, voting runs in **preview mode** and is saved only in that browser. It is not shared with other visitors.

## Enable shared team voting with Supabase

The poll uses Supabase so that votes are shared across visitors and devices. Voters enter a display name and select a named villa option. A browser-generated voter key lets a person update their vote from the same browser. This is a lightweight preference poll, not verified employee authentication; clearing browser storage or using another browser/device can create another voter key.

1. Create a Supabase project.
2. Open **SQL Editor** in the Supabase dashboard.
3. Run the SQL in `supabase/voting.sql`.
4. Open **Project Settings → API** (or API Keys) and copy the Project URL and public anon/publishable key.
5. In Coolify, add these runtime environment variables to the application:
   - `SUPABASE_URL` = your Supabase Project URL
   - `SUPABASE_ANON_KEY` = your public anon/publishable key
6. Redeploy the application. The poll status should change from **Preview mode** to **Shared team voting**.

Only use the public anon/publishable key in the website. **Never** put the Supabase `service_role` or secret key in browser code or Coolify environment variables for this frontend. The SQL exposes only aggregate counts and a vote-submission function; direct table access is revoked and row-level security is enabled.

## Deploy on Coolify with Dockerfile

1. Push this project folder to a GitHub repository.
2. In Coolify, choose **New Resource → Application**, then connect the repository.
3. Select the branch you want to deploy.
4. Choose the **Dockerfile** build pack (not a static/Nixpacks build).
5. Set the Dockerfile path to `/Dockerfile` if Coolify asks for it.
6. Set the exposed/container port to `80`.
7. Add the Supabase environment variables described above. If you have not configured Supabase yet, you can omit them; the website will still load in preview voting mode.
8. Add your domain in the Domains section, using the HTTP scheme/port expected by your Coolify proxy (normally the app container listens on port `80`).
9. Save and deploy. Once the deployment is healthy, open the generated domain and test the villa cards, mobile navigation, train route links and poll.

The included `nginx.conf` serves the static site and `/healthz` health endpoint. `entrypoint.sh` writes `/config.js` at container startup from Coolify's runtime environment variables, so Supabase credentials do not need to be baked into the image.

## Notes

- Photos are loaded from the respective property websites and other image hosts, so the deployed website needs outbound internet access. Check image usage/permissions with the property operators before using the website publicly.
- Villa availability, exact layouts, guest capacity, lake access and inclusions must be reconfirmed with each property before selection.
- The train section intentionally does not display train times. After travel days are decided, verify a Central Railway intercity/express service that stops at Lonavala through IRCTC/NTES. The Dadar → Lonavala leg is not described as a normal suburban Central Line local.
# plan
