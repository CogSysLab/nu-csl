---
layout: page
permalink: /people
title: Team
description: Members and close collaborators of the group.
nav: true
nav_order: 7
---
<p style="font-size: 1em;">Click on any of the lab members to get more information!.</p>

{% assign groups = site.members | sort: "group_rank" | map: "group" | uniq %}
{% for group in groups %}
<div style="margin-bottom: 60px;"></div> <!-- Spacer for additional spacing -->

{% if group != "Alumni" %}

## {{ group }}

    {% assign members = site.members | sort: "lastname" | where: "group", group %}
    {% for member in members %}

<p>
        {% include profiles/current_member.html member=member %} <!-- Include the member card here -->
</p>
{% endfor %}

{% endif %}
{% endfor %}





## Alumni
{% assign members = site.members | sort: "lastname" | where: "group", "Alumni" %}

<div class="alumni-container" style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 10px;">
    {% for member in members %}
    <div class="alumni-item" style="flex: 0 1 200px; max-width: 70%; text-align: center; margin: 10px;">
        <div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
            {% include profiles/past_member.html member=member %} <!-- Include the past member card here -->
        </div>
    </div>
    {% endfor %}
</div>