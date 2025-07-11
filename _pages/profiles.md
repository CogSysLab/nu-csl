---
layout: page
permalink: /people
title: Team
description: Members and close collaborators of the group.
nav: true
nav_order: 7
hide_title: true
header-background-image: "/assets/img/header/teambackground.webp"
social: true
---
<p style="font-size: 1em;">Click on any of the lab members to get more information!.</p>

{% assign groups = site.members | sort: "group_rank" | map: "group" | uniq %}
{% for group in groups %}
<div style="margin-bottom: 60px;"></div> <!-- Spacer for additional spacing -->

{% if group != "Alumni" %}

<h2 style="font-size: clamp(1.5rem, 4vw, 2.5rem);">{{ group }}</h2> <!-- Dynamic title font size -->

    {% assign members = site.members | sort: "lastname" | where: "group", group %}
    {% for member in members %}


<p>
        {% include profiles/current_member.html member=member %} <!-- Include the member card here -->
</p>
{% endfor %}

{% endif %}
{% endfor %}





<h2 style="font-size: clamp(1.5rem, 4vw, 2.5rem);">Alumni</h2> <!-- Dynamic title font size -->
{% assign members = site.members | sort: "lastname" | where: "group", "Alumni" %}
<div class="alumni-container d-flex flex-wrap flex-row justify-content-between align-items-center gap:2px">
    {% for member in members %}
    <div class="alumni-item" style="flex: 0 1 150px; max-width: 100%; text-align: center; margin: 0px; flex-direction: row;">
        <div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
            {% include profiles/past_member.html member=member %} <!-- Include the past member card here -->
        </div>
    </div>
    {% endfor %}
</div>
