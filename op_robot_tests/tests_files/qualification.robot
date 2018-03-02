*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider

${award_index}      ${0}


*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}


Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert to integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення опису вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення ідентифікатора вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.complaintID} для користувача ${viewer}


Відображення заголовку вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  ${right}=  Run As  ${viewer}  Отримати інформацію із документа до скарги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}'].claim_data.complaintID}
  ...      ${USERS.users['${provider}'].claim_data.doc_id}
  ...      title
  ...      ${award_index}
  Порівняти об'єкти  ${USERS.users['${provider}'].claim_data.doc_name}  ${right}


Відображення вмісту документа до вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].claim_data.doc_id} до скарги ${USERS.users['${provider}'].claim_data.complaintID} з ${USERS['${provider}'].claim_data.doc_content} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  ${status}=  Set variable if  'esco' in '${MODE}'  pending  claim
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із ${status} для користувача ${viewer}


Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


Відображення типу вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця

Відображення статусу 'resolved' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення визначення переможця в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення скасованого статусу вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${status}=  Set variable if  'esco' in '${MODE}'  stopping  cancelled
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із ${status} для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}

##############################################################################################
#             QUALIFICATION
##############################################################################################

Можливість дочекатися перевірки переможців по ЄДРПОУ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Перевірка користувача по ЄДРПОУ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      qualifications_check_by_edrpou
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Дочекатися перевірки кваліфікацій  ${tender_owner}  ${TENDER['TENDER_UAID']}

# The following test cases are used in one-lot procedures.

Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_first_award
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   0
  Remove File  ${file_path}


Можливість підтвердити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_first_award
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_first_award
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  0


Можливість відхилити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_second_award
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  1


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження нового постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_third_award
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   2
  Remove File  ${file_path}


Можливість підтвердити нового постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_third_award
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  2

# The following test cases are used in multi-lot procedures.

Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_second_award
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${file_path}   ${TENDER['TENDER_UAID']}   1
  Remove File  ${file_path}


Можливість підтвердити другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_award
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Можливість скасувати рішення кваліфікації для другого постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_second_award
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  1


Можливість відхилити решту постачальників
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_reject_other_awards
  Можливість дискваліфікувати решту постачальників  ${tender_owner}  ${TENDER['TENDER_UAID']}


*** Keywords ***
Можливість дискваліфікувати решту постачальників
  [Arguments]  ${username}  ${tender_uaid}
  Run as  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}
  ${awards_to_rejects}=  Run As  ${username}  Отримати кількість об'єктів  awards
  :FOR  ${award_index}  IN RANGE  2  ${awards_to_rejects*2-2}
  \  Run As  ${username}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  ${award_index}

# Award[0] and award[1] are activated. Then the latter is cancelled and reappears in 'pending' status.
# After each 'pending' award is cancelled, another award of the same lot, but another bidder appears.
# Thus, cancelling 'pending' awards, the number of awards to cancel is doubled. Award [2] is already cancelled.