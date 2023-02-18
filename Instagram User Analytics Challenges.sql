/*
You are required to provide a detailed report answering the questions below :
A) Marketing: The marketing team wants to launch some campaigns, and they need your help with the following

1. Rewarding Most Loyal Users: People who have been using the platform for the longest time.
   Your Task: Find the 5 oldest users of the Instagram from the database provided */

      select id,username from users 
      order by created_at 
      limit 5;
   
/* 2. Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.
	  Your Task: Find the users who have never posted a single photo on Instagram  */
      
       with cte as(select u.id,u.username from users u left join photos p 
	   on u.id=p.user_id 
	   where p.user_id is null) 
       select id,username from cte;
      
/* 3. Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest now they wish to declare the winner.
   Your Task: Identify the winner of the contest and provide their details to the team  */
   
       SELECT u.id, u.username, p.id, p.image_url, count(*) AS total_likes FROM photos p 
       JOIN likes l ON p.id = l.photo_id 
       JOIN users u ON u.id = p.user_id 
       GROUP BY p.id ORDER BY total_likes DESC LIMIT 1; 
      
/* 4.Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
	 Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform  */
      
       select t.id,t.tag_name,count(*) as tag_count,p.photo_id 
       from tags t join photo_tags p on t.id=p.tag_id 
       group by t.id order by tag_count desc limit 5;
       
/* 5.Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
	 Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign  */
     
       select weekday(created_at) from users 
       group by weekday(created_at) 
       order by count(weekday(created_at)) desc limit 1 ; 
       
/*6. We also have a problem with celebrities
Find users who have never commented on a photo*/

       SELECT username,comment_text
       FROM users
       LEFT JOIN comments ON users.id = comments.user_id
       GROUP BY users.id
       HAVING comment_text IS NULL;
       
/*7.Find users who have ever commented on a photo*/
       SELECT username,comment_text
       FROM users
	   LEFT JOIN comments ON users.id = comments.user_id
       GROUP BY users.id
       HAVING comment_text IS NOT NULL; 
       
/* 8.total numbers of users who have posted at least one time */
       SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
       FROM users
       JOIN photos ON users.id = photos.user_id;       
       
/* B) Investor Metrics: Our investors want to know if Instagram is performing well and is not becoming redundant like Facebook, they want to assess the app on the following grounds

    1.User Engagement: Are users still as active and post on Instagram or they are making fewer posts
      Your Task: Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users    */
      
      SELECT ROUND( 
      (SELECT COUNT(*) FROM photos ) / ( SELECT COUNT(*) FROM users ),1) 
      AS avg_user_post;
      
	/*2. user ranking by postings higher to lower*/
      SELECT users.username,COUNT(photos.image_url)
      FROM users
      JOIN photos ON users.id = photos.user_id
      GROUP BY users.id
      ORDER BY 2 DESC;
      
   /*3. Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
        Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this). */
        
        SELECT u.id ,u.username,COUNT(*) AS total_likes 
		FROM users u JOIN likes l ON u.id = l.user_id 
		GROUP BY u.id 
		HAVING total_likes = (SELECT COUNT(*) FROM photos);
        
        
       
       
      
