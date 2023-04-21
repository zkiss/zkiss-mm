---
title: "REST API Evolution"
categories: [Coding, 'How To']
tags: API evolution
---



<!--more-->


# Outline

1. Backwards compatibility in general
    1. Definition: api change does not break existing api use cases within a notice period
    1. In return, clients must be notified and must cooperate within notice period
    1. Rules
        1. API Outputs (Models)
            1. old semantics must be kept (during notice period)
            1. addition of new (properties/enums) always OK
            1. Removal: use notice period
                1. deprecate first, keep old behaviour during notice period 
                1. remove deprecated after notice period
                    (should be unused by that time)
        1. API Inputs
            1. Old calls must function with same behaviour
            1. new params: use notice period
                1. optional, with default value during notice period
                1. Enforce mandatory after notice period
            1. remove param: always OK, but must accept and ignore
    1. Scope: time based, version based, depends on what works best for the API in question
        1. public/internal API
        1. client ops model (user controlled vs centrally managed)
            1. number of clients (type, ie how many different things are using the API)
            1. ownership of clients (same team/multiple teams - bit like internal/external)
            1. lifetime of clients (how long a released client is in use for)
                1. developer controlled
                1. vs user controlled
        1. server ops model (single centrally managed server or multiple standalone deployments operated independently)
    1. Types: library (static - compile time / dynamic - runtime/ rpc)
1. API Evolution
    1. Get from one API definition to the next with no downtime, using incremental, backwards compatible changes
    1. It can take a long time + lot of effort to refactor an API using a linear API evolution model
    1. semver + parallel supported versions
1. Scenario: user controlled client + central backend