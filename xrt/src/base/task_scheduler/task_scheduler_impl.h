// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef BASE_TASK_SCHEDULER_TASK_SCHEDULER_IMPL_H_
#define BASE_TASK_SCHEDULER_TASK_SCHEDULER_IMPL_H_

#include <stddef.h>

#include <memory>
#include <string>
#include <vector>

#include "base/base_export.h"
#include "base/callback.h"
#include "base/logging.h"
#include "base/macros.h"
#include "base/memory/ref_counted.h"
#include "base/synchronization/waitable_event.h"
#include "base/task_runner.h"
#include "base/task_scheduler/delayed_task_manager.h"
#include "base/task_scheduler/scheduler_worker_pool_impl.h"
#include "base/task_scheduler/sequence.h"
#include "base/task_scheduler/task_scheduler.h"
#include "base/task_scheduler/task_tracker.h"
#include "base/task_scheduler/task_traits.h"
#include "base/threading/thread.h"

namespace base {
namespace internal {

class SchedulerServiceThread;

// Default TaskScheduler implementation. This class is thread-safe.
class BASE_EXPORT TaskSchedulerImpl : public TaskScheduler {
 public:
  struct WorkerPoolCreationArgs {
    // Name of the pool. Used to label the pool's threads.
    std::string name;

    // Priority of the pool's threads.
    ThreadPriority thread_priority;

    // Whether I/O is allowed in the pool.
    SchedulerWorkerPoolImpl::IORestriction io_restriction;

    // Maximum number of threads in the pool.
    size_t max_threads;
  };

  // Returns the index of the worker pool in which a task with |traits| should
  // run. This should be coded in a future-proof way: new traits should
  // gracefully map to a default pool.
  using WorkerPoolIndexForTraitsCallback =
      Callback<size_t(const TaskTraits& traits)>;

  // Creates and returns an initialized TaskSchedulerImpl. CHECKs on failure.
  // |worker_pools| describes the worker pools to create.
  // |worker_pool_index_for_traits_callback| returns the index in |worker_pools|
  // of the worker pool in which a task with given traits should run.
  static std::unique_ptr<TaskSchedulerImpl> Create(
      const std::vector<WorkerPoolCreationArgs>& worker_pools,
      const WorkerPoolIndexForTraitsCallback&
          worker_pool_index_for_traits_callback);

  // Destroying a TaskSchedulerImpl is not allowed in production; it is always
  // leaked. In tests, it can only be destroyed after JoinForTesting() has
  // returned.
  ~TaskSchedulerImpl() override;

  // TaskScheduler:
  void PostTaskWithTraits(const tracked_objects::Location& from_here,
                          const TaskTraits& traits,
                          const Closure& task) override;
  scoped_refptr<TaskRunner> CreateTaskRunnerWithTraits(
      const TaskTraits& traits,
      ExecutionMode execution_mode) override;
  void Shutdown() override;

  // Joins all threads of this scheduler. Tasks that are already running are
  // allowed to complete their execution. This can only be called once.
  void JoinForTesting();

 private:
  explicit TaskSchedulerImpl(const WorkerPoolIndexForTraitsCallback&
                                 worker_pool_index_for_traits_callback);

  void Initialize(const std::vector<WorkerPoolCreationArgs>& worker_pools);

  // Returns the worker pool that runs Tasks with |traits|.
  SchedulerWorkerPool* GetWorkerPoolForTraits(const TaskTraits& traits);

  // Callback invoked when a non-single-thread |sequence| isn't empty after a
  // worker pops a Task from it.
  void ReEnqueueSequenceCallback(scoped_refptr<Sequence> sequence);

  // Callback invoked when the delayed run time is changed from the
  // DelayedTaskManager.
  void OnDelayedRunTimeUpdated();

  TaskTracker task_tracker_;
  DelayedTaskManager delayed_task_manager_;
  const WorkerPoolIndexForTraitsCallback worker_pool_index_for_traits_callback_;
  std::vector<std::unique_ptr<SchedulerWorkerPoolImpl>> worker_pools_;
  std::unique_ptr<SchedulerServiceThread> service_thread_;

#if DCHECK_IS_ON()
  // Signaled once JoinForTesting() has returned.
  WaitableEvent join_for_testing_returned_;
#endif

  DISALLOW_COPY_AND_ASSIGN(TaskSchedulerImpl);
};

}  // namespace internal
}  // namespace base

#endif  // BASE_TASK_SCHEDULER_TASK_SCHEDULER_IMPL_H_
