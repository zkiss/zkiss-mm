---
title: "Embracing DDD at FOODit"
subtitle: An Eric Evans Workshop
categories: design ddd
tags: ddd 'layered architecture' orm aggregate 'domain model' 'bounded context'
---

_This post was originally published [here][orig] on 2016-05-31._

[orig]: https://medium.com/devs-foodit/embracing-ddd-at-foodit-an-eric-evans-workshop-ca9ba9ff0d5f

I had never done or had mentionable knowledge of DDD before joining [FOODit][foodit].
We are currently in the process of breaking up a ‘[Big Ball of Mud][bbm]’ into smaller bits
(some might even say microservices) to make the code more extensible, readable and maintainable.
In the process of doing so we are trying hard to apply Domain Driven Design principles.

[foodit]: https://foodit.com/
[bbm]: https://en.wikipedia.org/wiki/Big_ball_of_mud

<!--more-->

So I decided to use my learning budget provided by FOODit on a four day [DDD immersion course][course]
designed by Eric Evans himself, presented by [Alberto Brandolini][alberto].
Since I booked the training much in advance I also had time to read most of ‘[The Book][book]’ itself.

[course]: https://skillsmatter.com/courses/202-domain-model
[alberto]: https://skillsmatter.com/members/ziobrando
[book]: https://www.amazon.co.uk/Domain-driven-Design-Tackling-Complexity-Software/dp/0321125215

# Traditions

During most of my career I have been exposed to a layered design pattern, which, in my opinion,
is the traditional way of coding in Java:

- Data is accessed with some [ORM][orm] framework using [Java Bean][jbean] Entities through [DAOs][dao].
- Services are using DAOs to load the Entities, changing their state directly by manipulating
    their fields and saving them back to the database using the DAOs and/or calling other
    Services to execute shared logic.
- Controllers expose some of the Service functionality as endpoints on a server to be called
    by remote clients.

[orm]: https://en.wikipedia.org/wiki/Object-relational_mapping
[jbean]: https://en.wikipedia.org/wiki/JavaBeans
[dao]: https://en.wikipedia.org/wiki/Data_access_object

This setup means that all the logic resides in the Services.

The reasoning behind this, in my opinion, is that ORM frameworks cannot always handle logic
in Entities very well.

- They always need a no-arg constructor.
- They are setting individual field values directly on the Entities, irrespective of class invariants.
- They might misinterpret methods as properties or not recognise fields as properties
    without getters and setters.
- They might even do weird stuff to fields initialised in a constructor.

And many more. Not too long ago I ran into the following not working properly:

```java
@Entity
public class Basket {
  // there can only be 1 special item
  private List<SpecialBasketItem> specials;

  public Basket() {
    specials = Collections.emptyList();
  }

  public void addSpecial(SpecialBasketItem specialItem) {
    specials = Collections.singletonList(specialItem);
  }

  public void removeSpecial() {
    specials = Collections.emptyList();
  }
}
```

Turns out, the ORM framework we use tries to add elements to the list created in the constructor
when loading back the saved Entity from the database.
Which fails because `Collections.emptyList()` returns a non-modifiable list.

One needs to know the exact way the chosen ORM framework works and work around that.
The simplest way to do that is to just use plain Java Beans as Entities.

But this does not stop with ORM frameworks.
So many of them support Java Beans out of the box and make it so easy to just create them and pass
them around and into other frameworks, that it is very hard to resist not doing so.

This, however, [goes against][anemic] the basic OO principle of having the data and the logic which
operates on it at the same place: the Object itself.

[anemic]: http://martinfowler.com/bliki/AnemicDomainModel.html

Turns out, there is another way.

# DDD Definitions

In the DDD world, certain things have a slightly different meaning:

- _[Entities][evans]_: In DDD Entities are things which evolve over time, they have an identity,
    a continuity, which needs to be maintained.
    A User class in a piece of software is very likely to be an Entity, for example.
    In case the name changes, we still want the User object to be the same user object, conceptually.
- _[Value Objects][evans]_: Immutable representation of data and operations on it.
    What matters is the value of the fields in Value Objects, not the reference itself.
    A perfect example for Value Object is String in Java.
    We don’t care if the String object in our User object representing the name is the same over time,
    we only care about its value: the sequence of characters in there.
- _[Aggregates][aggregate]_: An object with continuity and complex internal structure.
    It hides its internals from the outside and makes it impossible to manipulate its state
    through objects it exposes.
    This way it ensures that its invariants are always maintained.
    Can be thought of as a transactional unit.
    An example could be an `Itinerary` object which maintains a list of `Leg`s
    (with `start` and `destination` properties).
    One of its invariants could be that it has to be connected;
    the list of `Leg`s have to be in such an order that the `start` attribute of a `Leg`
    is the same as the `destination` of the previous one.
- _[Service Objects][evans]_: Sometimes there is business logic which deals with more than
    one thing at the same time and would be awkward to put in either of those things.
    Services are where procedural business logic lives.
- _[Bounded context][bc]_: A set of classes (potentially software module) within which a
    consistent _[Ubiquitous Language][ulan]_ is defined.
    The _Ubiquitous Language_ consists of class names, property names, module names with
    a well defined meaning within the _Bounded Context_ it belongs to.
    The main goal of having and maintaining a _Ubiquitous Language_ is to avoid ambiguity in conversation.
    Within _Bounded Contexts_ there is an integrity of classes and terminology.
    When data is transferred between _Bounded Contexts_, a mapping is performed.

[evans]: http://martinfowler.com/bliki/EvansClassification.html
[aggregate]: http://martinfowler.com/bliki/DDD_Aggregate.html
[bc]: http://martinfowler.com/bliki/BoundedContext.html
[ulan]: http://martinfowler.com/bliki/UbiquitousLanguage.html

# Proper Domain Model

So let’s not separate the logic from the data!
By building a non [anemic][anemic] domain model in a simpler _Bounded Context_ we can end up with a
model which implements the functionality without having any Services.

One of the main benefits of doing this is that tests become a lot nicer.
The verifications performed are a lot closer to spoken language, therefore they are much easier to
read and maintain than they would have been otherwise.

For example, let’s assume we’re testing a `RoutingService` with an anemic domain model.
A test for rerouting will look similar to this:

```java
@Test
public void rerouting() {
  Itinerary i = createItinerary("HKG", "LGB", "DAL");
  // createItinerary uses setter and Leg constructor
  // to construct the new Itinerary
  
  Itinerary rerouted = routingService.reroute(i, "LGB", "SEA");

  assertEquals(rerouted.getLegs().size(), 2);
  assertEquals(rerouted.getLegs().get(0).getStart(), "HKG");
  assertEquals(rerouted.getLegs().get(0).getEnd(), "LGB");
  assertEquals(rerouted.getLegs().get(1).getStart(), "LGB");
  assertEquals(rerouted.getLegs().get(1).getEnd(), "SEA");
}
```

Now let’s assume that `Itinerary` ensures that the `Leg`s in it are connected and it also has logic
to manage its internals and expose data in a controlled way:

```java
@Test
public void rerouting() {
  Itinerary i = new Itinerary("HKG", "LGB", "DAL");
  
  Itinerary rerouted = routingService.reroute(i, "LGB", "SEA");

  assertEquals(rerouted.start(), "HKG");
  assertEquals(rerouted.end(), "SEA");
  assertTrue(rerouted.goesThrough("LGB"));
}
```

The reason we can rely on this test is that the `Itinerary` object rejects operations
which would put it in a non-connected state, so we know that it is always connected.
We also have to write tests for the `Itinerary` class, of course, testing that the class
invariants (being connected in this case) are being enforced.

If we write our _Entities_ and _Aggregates_ this way, our _Services_ will become really simple.

# Don’t Be Shy with Bounded Contexts

I can’t speak for everyone, but I know that up until very recently I thought that developing
a single clean, unambiguous model in a project is a realistic, desirable goal.
The thing is, it _is_ possible, however, it is not always feasible.

Sometimes resolving ambiguity is not worth the effort.
In practice it would mean changing the language everyone speaks by forcing a terminology on them.
People will not accept it and will continue using their own words.
This is especially true to people who are not part of the development team, like field experts
or the intended users of the software.

When clearing up ambiguity is hard we are better off explicitly declaring multiple _Bounded Contexts_.
The reason for this is that in smaller contexts the code can always be clear, but as soon as
it starts having awkward names because of a failed unification attempt, people will start
misunderstanding and misusing it.
Alberto’s advice: create a separate _Bounded Context_ for each expert.

This can work well with software modules with different responsibilities.
The same conceptual thing can have a different role or purpose in different modules,
so it makes sense in those different modules to have a role-specific model.

## CQRS!

From all this, [CQRS][cqrs] derives logically.
Just think about it.
Data can be read and written; these are two different responsibilities (Command and Query),
so it is best to separate them!
This is especially true when the same data needs to be shown in multiple different ways in specialised reports.
In this case, it makes sense to update the separate report views of the data when modifications
occur instead of constantly recreating them with complicated queries on demand.

[cqrs]: http://martinfowler.com/bliki/CQRS.html

As soon as this happens, we have separate _Bounded Contexts_ for writing and all the views.
Also, at this point views do not even have to be backed by the same database.
Since they are specialised, we can use any DB technology which supports the view in question the best.
Using events to propagate changes to all the specialised views makes sense,
which is almost what [Event Sourcing][eventsource] is all about!

[eventsource]: http://martinfowler.com/eaaDev/EventSourcing.html

# NORM

If we evolve to a stage where each view or report is a different _Bounded Context_
and we update them with events the question emerges: is there still a reason to use an ORM framework?

On the write side, we can just save the events which describe how the _Aggregate_ or _Entity_ has changed.
The same events propagate to all the views which update their own representations of the _Aggregate_.
On the write side we save the events and reconstruct the _Aggregate_ based on them
(for this we will obviously need to save intermediary states of the Aggregate as well,
in order to not have to read up _all_ the events in the Aggregate’s lifetime,
but the Aggregate can always be reconstructed from the events only!).

No traditional ORM supports this as far as I know.
But even if Event Sourcing is not in place, an ORM framework could be a significant factor restricting the model design.

The thing is, the point of ORM frameworks is to relieve us from having to deal with the low level
management of data and map it straight into our domain model; and also provide transparent mapping to
different database engines with more or less success.
But they come with restrictions which could prevent us from building the domain model we’d otherwise like to build.

With Spring’s `JdbcTemplate` it is not that hard to execute queries and map them to objects ourselves
and at least with that there are no constraints on how the domain model is coded.

As with anything else, it is a tradeoff; I think ORMs are good to get things started quickly
but as soon as sophistication is needed in the model, they might not be the best solution.

# Embracing DDD

In light of all this we at FOODit have decided to take our domain modelling to the next level
and start having logic in there.
In our first attempt to do this, the logic turned out to be quite nice and understandable.

The ORM framework we are using ([Objectify][ofy]) did have some surprises, but overall it seems to work
with some of the logic living in the _Entities_.
I am confident that this is a better approach than the Service-heavy layered architecture
we were doing before, and that it will help us build microservices the way they are supposed to be built.

[ofy]: https://github.com/objectify/objectify