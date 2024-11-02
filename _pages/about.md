---
layout: about
title: About
permalink: /
subtitle: <a href='#'>Affiliations</a>. Address. Contacts. Motto. Etc.

profile:
  align: right
  image_circular: false # crops the image to make it circular
  more_info: >
    <p>555 your office number</p>
    <p>123 your address street</p>
    <p>Your City, State 12345</p>

news: true # includes a list of news items
selected_papers: true # includes a list of papers marked as "selected={true}"
social: true # includes social icons at the bottom of the page
---

<!-- Image Carousel -->
<div id="imageCarousel" class="carousel slide mb-4" data-ride="carousel">
    <div class="carousel-inner">
        {% assign images = site.data.gallery.images %}
        {% for img in images %}
            <div class="carousel-item {% if forloop.first %}active{% endif %}">
                <img src="/neu-csl/assets/img/gallery/{{ img.file_name }}" class="d-block w-100" alt="Image description {{ forloop.index }}">
                {% if img.description %}
                    <div class="carousel-caption d-none d-md-block" style="background-color: rgba(255, 255, 255, 0.5); padding: 0; width: 100%; left: 50%; transform: translateX(-50%); bottom: 60px;">
                        <h5 style="margin: 0.7em; text-align: center; color: rgba(65, 65, 65, 1.0); font-size: 1.5rem;">{{ img.description }}</h5> <!-- Change the color as needed -->
                    </div>
                {% endif %}
            </div>
        {% endfor %}
    </div>
    <a class="carousel-control-prev" href="#imageCarousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#imageCarousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
    <ol class="carousel-indicators">
        {% for img in images %}
            <li data-target="#imageCarousel" data-slide-to="{{ forloop.index0 }}" class="{% if forloop.first %}active{% endif %}"></li>
        {% endfor %}
    </ol>
</div>

<p>
The <span style="color: blue;"> Cognitive Systems Laboratory </span> (CSL) is (a) a member of the Center for SPIRAL — a nexus of signal and image analytics and machine learning, (b) a member of the self-organized PEN (Psychologists, Engineers, Neuroscientists) Cluster at Northeastern — a nexus of experimental and modeling driven studies of brain and peripheral nervous system and their interactions with the body, (c) a member of the inter-institutional CAMBI — a nexus of assistive technology research and development including brain interfaces, and (d) a member of the inter-institutional i-ROP Consortium — a nexus of research and development of retinopathy of prematurity assessment and treatment monitoring technologies. 
</p>