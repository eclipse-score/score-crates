..
   # *******************************************************************************
   # Copyright (c) 2026 Contributors to the Eclipse Foundation
   #
   # See the NOTICE file(s) distributed with this work for additional
   # information regarding copyright ownership.
   #
   # This program and the accompanying materials are made available under the
   # terms of the Apache License Version 2.0 which is available at
   # https://www.apache.org/licenses/LICENSE-2.0
   #
   # SPDX-License-Identifier: Apache-2.0
   # *******************************************************************************

Safety Plan
***********

.. document:: score-crates Safety Plan
  :id: doc__score_crates_safety_plan
  :status: draft
  :safety: ASIL_B
  :security: NO
  :realizes: wp__module_safety_plan


:note: The module safety plan shall be continuously maintained during the project.
       Deviations to the module safety plan should be documented :ref:`here <score_crates_safety_package_deviations>`

Functional Safety Management Context
====================================

This Safety Plan adds to the project's :need:`wp__platform_safety_plan` all the module development relevant work products needed for ISO 26262 conformity.

Functional Safety Management Scope
==================================

This Safety Plan's scope is a SW module of the SW platform - this moddule is a container for Rust libraries (crates).
The module consists of one or more SW components and will be qualified as a SEooC.

Functional Safety Management Roles
==================================

.. list-table:: Module roles
        :header-rows: 1

        * - Role
          - Assignee

        * - Safety Manager
          - <link to Module's Safety Manager assignment or name>

        * - Module Project Manager
          - <link to Module's Project Manager assignment or name>

Tailoring
=========

No addition to the tailoring in the SW platform project as defined in the project's :need:`wp__platform_safety_plan`.

Functional Safety Module Work products
======================================

One set of work products for the module and one set for each component of the module:

Module Work products List
-------------------------

.. list-table:: Module Work products
        :header-rows: 1

        * - Work product Id
          - Link to process
          - Process status
          - Link to WP

        * - :need:`wp__module_safety_plan`
          - :need:`gd_guidl__saf_plan_definitions`
          - :ndf:`copy('status', need_id='gd_guidl__saf_plan_definitions')`
          - this document

        * - :need:`wp__module_safety_package`
          - :need:`gd_guidl__saf_package`
          - :ndf:`copy('status', need_id='gd_guidl__saf_package')`
          - this document (including the linked documentation)

        * - :need:`wp__fdr_reports` (module Safety Plan)
          - :need:`gd_chklst__safety_plan`
          - :ndf:`copy('status', need_id='gd_chklst__safety_plan')`
          - <Link to WP>

        * - :need:`wp__fdr_reports` (module Safety Package)
          - :need:`gd_chklst__safety_package`
          - :ndf:`copy('status', need_id='gd_chklst__safety_package')`
          - <Link to WP>

        * - :need:`wp__fdr_reports` (module's Safety Analyses & DFA)
          - :need:`gd_chklst__safety_analysis`
          - :ndf:`copy('status', need_id='gd_chklst__safety_analysis')`
          - <Link to WP>

        * - :need:`wp__audit_report`
          - performed by external experts
          - n/a
          - <Link to WP>

        * - :need:`wp__module_safety_manual`
          - :need:`gd_temp__safety_manual`
          - :ndf:`copy('status', need_id='gd_temp__safety_manual')`
          - <Link to WP>

        * - :need:`wp__verification_module_ver_report`
          - :need:`gd_temp__mod_ver_report`
          - :ndf:`copy('status', need_id='gd_temp__mod_ver_report')`
          - :need:`doc__score_crates_verification_report`

        * - :need:`wp__module_sw_release_note`
          - :need:`gd_temp__rel_mod_rel_note`
          - :ndf:`copy('status', need_id='gd_temp__rel_mod_rel_note')`
          - <Link to WP>

Component Pastey Work products List
-----------------------------------

.. list-table:: Component Pastey Work products
        :header-rows: 1

        * - Work product Id
          - Link to process
          - Process status
          - Link to WP

        * - :need:`wp__requirements_comp`
          - :need:`gd_temp__req_comp_req`
          - :ndf:`copy('status', need_id='gd_temp__req_comp_req')`
          - `component_requirements.trlc <https://github.com/eclipse-score/score-crates/blob/main/docs/pastey/docs/requirement/component_requirements.trlc>`_

        * - :need:`wp__requirements_comp_aou`
          - :need:`gd_temp__req_aou_req`
          - :ndf:`copy('status', need_id='gd_temp__req_aou_req')`
          - `aou.trlc <https://github.com/eclipse-score/score-crates/blob/main/docs/pastey/docs/safety_analysis/aou.trlc>`_

        * - :need:`wp__requirements_inspect`
          - :need:`gd_chklst__req_inspection`
          - :ndf:`copy('status', need_id='gd_chklst__req_inspection')`
          - <link to wp>

        * - :need:`wp__component_arch`
          - :need:`gd_temp__arch_comp`
          - :ndf:`copy('status', need_id='gd_temp__arch_comp')`
          - :need:`doc__mod_pastey_architecture`

        * - :need:`wp__sw_arch_verification`
          - :need:`gd_chklst__arch_inspection_checklist`
          - :ndf:`copy('status', need_id='gd_chklst__arch_inspection_checklist')`
          - n/a (tailored)

        * - :need:`wp__sw_component_fmea`
          - :need:`gd_temp__comp_saf_fmea`
          - :ndf:`copy('status', need_id='gd_temp__comp_saf_fmea')`
          - `failure_modes.trlc <https://github.com/eclipse-score/score-crates/blob/main/docs/pastey/docs/safety_analysis/failure_modes.trlc>`_

        * - :need:`wp__sw_component_dfa`
          - :need:`gd_temp__comp_saf_dfa`
          - :ndf:`copy('status', need_id='gd_temp__comp_saf_dfa')`
          - n/a (tailored)

        * - :need:`wp__sw_implementation`
          - :need:`gd_guidl__implementation`
          - :ndf:`copy('status', need_id='gd_guidl__implementation')`
          - n/a (tailored)

        * - :need:`wp__verification_sw_unit_test`
          - :need:`gd_guidl__verification_guide`
          - :ndf:`copy('status', need_id='gd_guidl__verification_guide')`
          - n/a (tailored)

        * - :need:`wp__sw_implementation_inspection`
          - :need:`gd_chklst__impl_inspection_checklist`
          - :ndf:`copy('status', need_id='gd_chklst__impl_inspection_checklist')`
          - n/a (tailored)

        * - :need:`wp__verification_comp_int_test`
          - :need:`gd_guidl__verification_guide`
          - :ndf:`copy('status', need_id='gd_guidl__verification_guide')`
          - `pastey_test.rs <https://github.com/eclipse-score/score-crates/blob/main/docs/pastey/tests/pastey_test.rs>`_

        * - :need:`wp__sw_component_class`
          - :need:`gd_guidl__component_classification`
          - :ndf:`copy('status', need_id='gd_guidl__component_classification')`
          - :need:`doc__pastey_crate_comp_class`

Note: In case the component is a new development, :need:`wp__sw_component_class` shall be removed from the above list (and also from the folders).
In case an OSS element is used in the module, part 6 has to be filled out.

OSS (sub-)component qualification plan
--------------------------------------

For the selected OSS component the following work products will be implemented (and why):

If the OSS element is classified as
    - component, then the below table shall match the above, adding the reasoning for tailoring of work products according to the OSS component classification.
    - lower level component, then no work products additional to the component’s will be planned and activities below are part of the component’s issues.

.. list-table:: OSS (sub-)component Pastey Work products
        :header-rows: 1

        * - Work product Id
          - Link to process
          - Reasoning for tailoring

        * - :need:`wp__requirements_comp`
          - :need:`gd_temp__req_comp_req`
          - Always needed (for Q and QR classification) and also improves process Id 2

        * - :need:`wp__requirements_comp_aou`
          - :need:`gd_temp__req_aou_req`
          - Always needed (for Q and QR classification) and also improves process Id 5

        * - :need:`wp__requirements_inspect`
          - :need:`gd_chklst__req_inspection`
          - needed

        * - :need:`wf__cr_mt_comparch`
          - :need:`gd_temp__arch_comp`
          - It is small crate structure with one public interface, architecture view showing this shall be provided.

        * - :need:`wp__sw_component_fmea`
          - :need:`gd_temp__comp_saf_fmea`
          - Safety analysis will be performed.

        * - :need:`wp__sw_arch_verification`
          - :need:`gd_chklst__arch_inspection_checklist`
          - Tailored - Not needed due to simplicity.

        * - :need:`wp__sw_implementation`
          - n/a
          - Tailored - If source code is modified, this is not a OSS qualification any more.

        * - :need:`wp__verification_sw_unit_test`
          - :need:`gd_guidl__verification_guide`
          - Tailored - already provided by OSS component, see https://github.com/AS1100K/pastey/tree/master/pastey-test-suite

        * - :need:`wp__sw_implementation_inspection`
          - :need:`gd_chklst__impl_inspection_checklist`
          - Tailored - OSS (design) documentation already exists, see https://docs.rs/pastey/0.2.3/pastey/

        * - :need:`wp__verification_comp_int_test`
          - :need:`gd_guidl__verification_guide`
          - Always needed (for Q and QR classification)

        * - :need:`wp__sw_component_class`
          - :need:`gd_guidl__component_classification`
          - Always needed as basis for tailoring.

Link to project planning
------------------------

<add here a link to your module's planning for the above work products, e.g. a link to a ticket.>

Module Safety Package
=====================

To create the safety package (according to :need:`gd_guidl__saf_package`) the following
documents and work products status have to go to "valid" (after the relevant verification were performed).

Module Documents Status
-----------------------

For all the work product documents the status can be seen by following the "Link to WP".
A summary of the status is also documented in the project's documentation management plan.

See <add here the section reference to the documentation management plan>

Component Documents Status
--------------------------

For all the work product documents the status can be seen by following the "Link to WP".
A summary of the status is also documented in the project's documentation management plan.

See <add here the section reference to the documentation management plan>

Component Requirements Status
-----------------------------

.. needtable::
  :filter: docname is not None and "component_name" in docname and "requirements" in docname
  :style: table
  :types: comp_req
  :tags: component_name
  :columns: id;status;tags
  :colwidths: 25,25,25
  :sort: title

Component AoU Status
--------------------

.. needtable::
  :filter: docname is not None and "component_name" in docname and "requirements" in docname
  :style: table
  :types: aou_req
  :tags: component_name
  :columns: id;status;tags
  :colwidths: 25,25,25
  :sort: title

Component Architecture Status
-----------------------------

.. needtable::
  :filter: docname is not None and "component_name" in docname and "architecture" in docname
  :style: table
  :types: comp_arc_sta; comp_arc_dyn
  :tags: component_name
  :columns: id;status;tags
  :colwidths: 25,25,25
  :sort: title

.. _score_crates_safety_package_deviations:

Deviations from Module Safety Plan
----------------------------------

The following deviations from the module safety plan are present in the module safety package.
These are deviations from planned processes execution and/or workproduct results,
safety anomalies in the sense of known bugs in the software are reported in the release notes.

<Describe here the deviations, whether they have an impact on module's safety functions,
how these can be mitigated or argued and if and when a resolution is planned.>
