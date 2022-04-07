package net.chikach.submon

import androidx.room.*

@Database(entities = [Submission::class, DoTime::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun submissionDao(): SubmissionDao
    abstract fun doTimeDao(): DoTimeDao
}

@Entity
data class Submission(
    @PrimaryKey val id: Int?,
    val date: String,
    val title: String,
    val done: Int,
    val detail: String,
    val important: Int,
    val color: Int,
    val repeat: Int,
)

@Dao
interface SubmissionDao {
    @Query("select * from submission where done = (0)")
    fun getAllUndone(): List<Submission>
}


@Entity
data class DoTime(
    @PrimaryKey val id: Int?,
    val submissionId: Int,
    val startAt: String,
    val done: Int,
    val minute: Int,
    val content: String
)

@Dao
interface DoTimeDao {
    @Query("update doTime set done = :done where id = :id")
    fun updateDone(id: Int, done: Int)
}