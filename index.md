---
layout: home
title: D&D Campaign Journal
subtitle: Chronicles of our adventures
---

## Campaigns

<ul class="card-list">
{% for campaign in site.data.campaigns %}
  <li>
    <a href="{{ site.baseurl }}/{{ campaign.slug }}/">{{ campaign.name }}</a>
    <p class="description">{{ campaign.tagline }}</p>
  </li>
{% endfor %}
</ul>
