---
layout: page
permalink: /repositories/
title: Code
description: Edit the `_data/repositories.yml` and change the `github_users`, `github_organizations`, and `github_repos` lists to include your own GitHub profile and repositories.
nav: true
nav_order: 4
hide_title: true
header-background-image: "/assets/img/header/codebackground.webp"
social: true
---

{% if site.data.repositories.github_users %}

## GitHub Users

<link rel="stylesheet" href="{{ '/assets/css/repo-profile.css' | relative_url }}">
<div class="repositories d-flex flex-wrap flex-row justify-content-between align-items-center">
  {% for user in site.data.repositories_combined.github_users %}
    {% include repository/repo_user.liquid username=user %}
  {% endfor %}
</div>

---

{% if site.repo_trophies.enabled %}

{% comment %}
{% for user in site.data.repositories_combined.github_users %}

{% if site.data.repositories.github_users.size > 1 %}

  <h4>{{ user }}</h4>

{% endif %}

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% include repository/repo_trophies.liquid username=user %}
</div>

{% endfor %}
{% endcomment %}

{% endif %}

{% endif %}

{% if site.data.repositories_combined.github_organizations %}

<!--
## GitHub Organizations

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for org in site.data.repositories_combined.github_organizations %}
    {% include repository/repo_organization.liquid username=org %}
  {% endfor %}
</div>

---

{% if site.repo_trophies.enabled %}
{% for org in site.data.repositories_combined.github_organizations %}
{% if site.data.repositories.github_organizations.size > 1 %}

  <h4>{{ org }}</h4>
{% endif %}
  <div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% include repository/repo_trophies.liquid username=org %}
  </div>

---

{% endfor %}
{% endif %}
{% endif %}
-->

{% if site.data.repositories_combined.github_repos %}

## GitHub Repositories

<!-- Search Bar -->
<div class="search-container mb-3">
  <input type="text" id="repoSearch" placeholder="Search Repositories..." onkeyup="filterRepos()">
</div>

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center" id="repoList">
  {% for repo in site.data.repositories_combined.github_repos %}
    {% include repository/repo.liquid repository=repo %}
  {% endfor %}
</div>

<script>
  function filterRepos() {
    var input, filter, repoList, repos, i, repoName;
    input = document.getElementById('repoSearch');
    filter = input.value.toLowerCase();
    repoList = document.getElementById("repoList");
    repos = repoList.getElementsByClassName('repo');

    for (i = 0; i < repos.length; i++) {
      repoName = repos[i].getAttribute('data-repo-name'); // Get the repo name from the data attribute
      if (repoName.indexOf(filter) > -1) {
        repos[i].style.display = ""; // Show the repo
      } else {
        repos[i].style.display = "none"; // Hide the repo
      }
    }
  }
</script>

{% endif %}
