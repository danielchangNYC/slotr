A bot to schedule your appointments.

Sally wants to arrange a late-hiring stage 30-minute phone interview of a candidate. The meeting will take place on the company dial-in bridge. She wants to invite the candidate and the hiring manager, and include herself as optional. In the past, coordinating a time was a pain. But now, she simply navigates to Slotr on her laptop or mobile device to get things setup. Slotr has access to her calendar and automatically suggests 30 minute windows that work for her. She selects several and then types in the names and e-mail addresses of candidate and hiring manager she’d like to invite. An e-mail is sent to them. The invitees click on the link and select and rank the time slots that work best for them. When all parties have responded Slotr sends a calendar invitation to each of them. At the head of each morning, Sally gets a summary e-mail showing her what meetings are being coordinated.

Jobs to be done:

When Sally wants to schedule a meeting, she can see when she is free and include the parties she wants to invite, so that an optimal time can be selected
When an invitee receives a message from Slotr, they want to easily be able to prioritize their available times, so that they can meet at the best possible time
When nobody is available, Sally wants to know as soon as possible, so she can send out new options
When Sally has lots of meetings out for coordination, Sally wants to know what state of scheduling there in, so that she can pester them if necessary


30 min interviews
Inlude people on the interview, including self
At the head of each morning, Sally gets a summary e-mail showing her what meetings are being coordinated.


// What calendar application does Sally use? Gcal? iCal?
// Does Slotr only deal with interviews?

USERS
has_one :profile  (No profile = not a scheduler)
has_many :user_contacts
has_many :contacts, through: user_contacts
email  (validate uniqueness)
first_name
last_name

PROFILES
google_uid
preferred_begins_at
preferred_ends_at
prefer_mon?
prefer_tues?
prefer_wed?
prefer_thurs?
prefer_fri?
prefer_sat?
prefer_sun?

USER_CONTACTS
belongs_to :user
belongs_to :contact, class_name: "User"

INTERVIEW_INTERVIEWERS
interview_id
user_id

INTERVIEWS
has_many :interviewers, through: :interview_interviewers, class_name: "User"
has_many :rejected_dates
belongs_to :scheduler, class_name: "User" (the user who created it)
  # scheduler_id
belongs_to :interviewee, class_name: "User"
  # interviewee_id
preferred_date_top
preferred_date_middle
preferred_date_bottom
begins_at
ends_at

REJECTED_DATES
belongs_to :interview
datetime

SCHEDULE_RESPONSES
belongs_to :interview
belongs_to :user
code
responded_on



// How does responding to the scheduler work?
www.slotr.com/schedule_responses/SDIUHFWEFOIJA23090KLSD
schedule_responses#response

sched_response = ScheduleResponse.find_by(code: params[:code])
user = sched_response.user
interview = sched_response.interview
role = interview.role_for(user)
