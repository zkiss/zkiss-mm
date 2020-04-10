# Zoltan's Page

{% for post in site.posts %}
<p>
    <a href="{{ post.url }}">{{ post.title }}</a>
    {{ post.excerpt }}
</p>
{% endfor %}
