class_name SpyTests extends TDTest

var MockSpyClass

func test_drive():
  before_each(func():
    MockSpyClass = mock(SpyTestClass)
  )

  group('basics', func():
    var build = (func():
      MockSpyClass.use_defaults()
      var instance = MockSpyClass.new()
      return {
        spy=spy(instance.returns_string),
        multi_spy=spy(instance.takes_multiple_args),
        instance=instance
      }
    )

    group('last_call', func():
      test('last_call is null if not called', func():
        var setup = build.call()
        assert_null(setup.spy.last_call)
      )

      test('last_call contains the last call information when called once', func():
        var setup = build.call()
        var instance = setup.instance
        var spy = setup.spy

        instance.returns_string('test')

        var call = spy.last_call
        assert_exists(call)
        assert_equal(call.args, ['test'])
        assert_equal(call.return_value, 'test')
      )

      test('last_call contains the last call information when called more than once', func():
        var setup = build.call()
        var instance = setup.instance
        var spy = setup.spy

        instance.returns_string('test 1')
        instance.returns_string('test 2')

        var call = spy.last_call
        assert_exists(call)
        assert_equal(call.args, ['test 2'])
        assert_equal(call.return_value, 'test 2')
      )
    )

    group('first_call', func():
      test('first_call is null if not called', func():
        var setup = build.call()
        assert_null(setup.spy.first_call)  
      )

      test('first_call contains information about the first call if called once', func():
        var setup = build.call()
        var instance = setup.instance
        var spy = setup.spy

        instance.returns_string('test 1')
        var call = spy.first_call
        assert_exists(call)
        assert_equal(call.args, ['test 1'])
        assert_equal(call.return_value, 'test 1')
      )

      test('first_call contains information about the first call if called more than once', func():
        var setup = build.call()
        var instance = setup.instance
        var spy = setup.spy

        instance.returns_string('test 1')
        instance.returns_string('test_2')
        var call = spy.first_call
        assert_exists(call)
        assert_equal(call.args, ['test 1'])
        assert_equal(call.return_value, 'test 1')
      )
    )

    group('called', func():
      test('called is false if not called', func():
        var setup = build.call()
        assert_false(setup.spy.called)  
      )

      test('called is true if the method was called once', func():
        var setup = build.call()
        setup.instance.returns_string('test')
        assert_true(setup.spy.called)
      )

      test('called is true if the method was called more than once', func():
        var setup = build.call()
        setup.instance.returns_string('test 1')
        setup.instance.returns_string('test 2')
        assert_true(setup.spy.called)
      )
    )

    group('num_calls', func():
      test('num_calls is 0 if not called', func():
        var setup = build.call()
        assert_equal(setup.spy.num_calls, 0)  
      )

      test('num_calls matches the number of calls no matter how many calls there are', func():
        var setup = build.call()
        for i in range(1, 100):
          setup.instance.returns_string('test {0}'.format([i]))
          assert_equal(setup.spy.num_calls, i)
      )
    )

    group('calls array', func():
      test('size of calls array is 0 if not called', func():
        var setup = build.call()
        assert_empty(setup.spy.calls)  
      )

      test('call information at the beginning of the calls array is accurate', func():
        var setup = build.call()
        setup.instance.returns_string('test 1')
        setup.instance.returns_string('test 2')
        setup.instance.returns_string('test 3')

        var call = setup.spy.calls[0]
        assert_exists(call)
        assert_equal(call.args, ['test 1'])
        assert_equal(call.return_value, 'test 1')
      )

      test('call information at the end of the calls array is accurate', func():
        var setup = build.call()
        setup.instance.returns_string('test 1')
        setup.instance.returns_string('test 2')
        setup.instance.returns_string('test 3')

        var call = setup.spy.calls[-1]
        assert_exists(call)
        assert_equal(call.args, ['test 3'])
        assert_equal(call.return_value, 'test 3')
      )

      test('call information in the middle of the calls array is accurate', func():
        var setup = build.call()
        setup.instance.returns_string('test 1')
        setup.instance.returns_string('test 2')
        setup.instance.returns_string('test 3')

        var call = setup.spy.calls[1]
        assert_exists(call)
        assert_equal(call.args, ['test 2'])
        assert_equal(call.return_value, 'test 2')
      )
    )

    group('ever_called_with()', func():
      group('for single calls', func():
        test('returns false when no call has ocurred', func():
          var setup = build.call()
          assert_false(setup.multi_spy.ever_called_with())
        )

        test('returns true when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_true(setup.multi_spy.ever_called_with())
          assert_true(setup.multi_spy.ever_called_with(1))
          assert_true(setup.multi_spy.ever_called_with(1, 2))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_true(setup.multi_spy.ever_called_with(1, 2, 3))
        )

        test('returns false when there are too many arguments passed in', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          assert_false(setup.spy.ever_called_with(1, 2, 3, 4))
        )

        test('returns false when the arguments provided do not match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_false(setup.spy.ever_called_with(3))
          assert_false(setup.spy.ever_called_with(3, 2))
          assert_false(setup.spy.ever_called_with(3, 2, 1))
          assert_false(setup.spy.ever_called_with(1, 3, 2))
          assert_false(setup.spy.ever_called_with(1, 2, 5))
        )
      )

      group('for multiple calls', func():
        test('returns true when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_true(setup.multi_spy.ever_called_with())
          assert_true(setup.multi_spy.ever_called_with(1))
          assert_true(setup.multi_spy.ever_called_with(1, 2))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_true(setup.multi_spy.ever_called_with(1, 2, 3))
          assert_true(setup.multi_spy.ever_called_with('d', 'e', 'f'))
          assert_true(setup.multi_spy.ever_called_with('a', 'b', 'c'))
        )

        test('returns false when there are too many arguments passed in', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_false(setup.multi_spy.ever_called_with(1, 2, 3, 4))
          assert_false(setup.multi_spy.ever_called_with(1, 2, 3, null))
          assert_false(setup.multi_spy.ever_called_with('a', 'b', 'c', 'd'))
          assert_false(setup.multi_spy.ever_called_with('a', 'b', 'c', null))
          assert_false(setup.multi_spy.ever_called_with('d', 'e', 'f', 0))
          assert_false(setup.multi_spy.ever_called_with('d', 'e', 'f', null))
        )

        test('returns false when the arguments provided do not match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_false(setup.multi_spy.ever_called_with(1, 2, 'a'))
          assert_false(setup.multi_spy.ever_called_with(1, 'a', 3))
          assert_false(setup.multi_spy.ever_called_with('a', 2, 3))
          
          assert_false(setup.multi_spy.ever_called_with(1, 'b', 'c'))
          assert_false(setup.multi_spy.ever_called_with('a', 2, 'c'))
          assert_false(setup.multi_spy.ever_called_with('a', 'b', 3))

          assert_false(setup.multi_spy.ever_called_with('a', 'e', 'f'))
          assert_false(setup.multi_spy.ever_called_with('d', 'b', 'f'))
          assert_false(setup.multi_spy.ever_called_with('d', 'e', 'c'))
        )
      )
    )

    group('ever_called_with_exactly()', func():
      group('for single calls', func():
        test('returns false when no call has ocurred', func():
          var setup = build.call()
          assert_false(setup.multi_spy.ever_called_with())
        )

        test('returns false when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_false(setup.multi_spy.ever_called_with_exactly())
          assert_false(setup.multi_spy.ever_called_with_exactly(1))
          assert_false(setup.multi_spy.ever_called_with_exactly(1, 2))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_true(setup.multi_spy.ever_called_with_exactly(1, 2, 3))
        )

        test('returns false when there are too many arguments passed in', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          assert_false(setup.spy.ever_called_with_exactly(1, 2, 3, 4))
        )

        test('returns false when the arguments provided do not match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)

          assert_false(setup.spy.ever_called_with_exactly(3, 2, 1))
          assert_false(setup.spy.ever_called_with_exactly(1, 3, 2))
          assert_false(setup.spy.ever_called_with_exactly(1, 2, 5))
        )
      )

      group('for multiple calls', func():
        test('returns false when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_false(setup.multi_spy.ever_called_with_exactly())
          assert_false(setup.multi_spy.ever_called_with_exactly(1))
          assert_false(setup.multi_spy.ever_called_with_exactly(1, 2))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_true(setup.multi_spy.ever_called_with_exactly(1, 2, 3))
          assert_true(setup.multi_spy.ever_called_with_exactly('d', 'e', 'f'))
          assert_true(setup.multi_spy.ever_called_with_exactly('a', 'b', 'c'))
        )

        test('returns false when there are too many arguments passed in', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_false(setup.multi_spy.ever_called_with_exactly(1, 2, 3, 4))
          assert_false(setup.multi_spy.ever_called_with_exactly(1, 2, 3, null))
          assert_false(setup.multi_spy.ever_called_with_exactly('a', 'b', 'c', 'd'))
          assert_false(setup.multi_spy.ever_called_with_exactly('a', 'b', 'c', null))
          assert_false(setup.multi_spy.ever_called_with_exactly('d', 'e', 'f', 0))
          assert_false(setup.multi_spy.ever_called_with_exactly('d', 'e', 'f', null))
        )

        test('returns false when the arguments provided do not match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args('a', 'b', 'c')
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args('d', 'e', 'f')

          assert_false(setup.multi_spy.ever_called_with_exactly(1, 2, 'a'))
          assert_false(setup.multi_spy.ever_called_with_exactly(1, 'a', 3))
          assert_false(setup.multi_spy.ever_called_with_exactly('a', 2, 3))
          
          assert_false(setup.multi_spy.ever_called_with_exactly(1, 'b', 'c'))
          assert_false(setup.multi_spy.ever_called_with_exactly('a', 2, 'c'))
          assert_false(setup.multi_spy.ever_called_with_exactly('a', 'b', 3))

          assert_false(setup.multi_spy.ever_called_with_exactly('a', 'e', 'f'))
          assert_false(setup.multi_spy.ever_called_with_exactly('d', 'b', 'f'))
          assert_false(setup.multi_spy.ever_called_with_exactly('d', 'e', 'c'))
        )
      )
    )

    group('last_called_with()', func():
      group('for single calls', func():
        test('returns false when there have been no calls', func():
          var setup = build.call()
          assert_false(setup.multi_spy.last_called_with())
        )

        test('returns true when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with(null))
          assert_true(setup.multi_spy.last_called_with(null, 1))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with(null, 1, 'a'))
        )

        test('returns false when there are too many arguments', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', null))
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', null, null))
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', 2, 3))
        )

        test('returns false when there is an argument mismatch', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with(1, null, 'a'))
          assert_false(setup.multi_spy.last_called_with(null, 'a', 1))
          assert_false(setup.multi_spy.last_called_with('a', 1, null))
          assert_false(setup.multi_spy.last_called_with(null, null, null))
        )
      )

      group('for multiple calls', func():
        test('returns true when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with(null))
          assert_true(setup.multi_spy.last_called_with(null, 1))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with(null, 1, 'a'))
        )

        test('returns false when trying to match an older call', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with(1, 2, 3))
        )

        test('returns false when there are too many arguments', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', null))
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', null, null))
          assert_false(setup.multi_spy.last_called_with(null, 1, 'a', 2, 3))
        )

        test('returns false when there is an argument mismatch', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with(1, null, 'a'))
          assert_false(setup.multi_spy.last_called_with(null, 'a', 1))
          assert_false(setup.multi_spy.last_called_with('a', 1, null))
          assert_false(setup.multi_spy.last_called_with(null, null, null))
        )
      )
    )

    group('last_called_with_exactly()', func():
      group('for single calls', func():
        test('returns false when there have been no calls', func():
          var setup = build.call()
          assert_false(setup.multi_spy.last_called_with_exactly())
        )

        test('returns false when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with_exactly(null, 1, 'a'))
        )

        test('returns false when there are too many arguments', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', null, null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', 2, 3))
        )

        test('returns false when there is an argument mismatch', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(1, null, 'a'))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 'a', 1))
          assert_false(setup.multi_spy.last_called_with_exactly('a', 1, null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, null, null))
        )
      )

      group('for multiple calls', func():
        test('returns false when there is a partial match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1))
        )

        test('returns true when there is an exact match', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_true(setup.multi_spy.last_called_with_exactly(null, 1, 'a'))
        )

        test('returns false when trying to match an older call', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(1, 2, 3))
        )

        test('returns false when there are too many arguments', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', null, null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 1, 'a', 2, 3))
        )

        test('returns false when there is an argument mismatch', func():
          var setup = build.call()
          setup.instance.takes_multiple_args(1, 2, 3)
          setup.instance.takes_multiple_args(null, 1, 'a')
          assert_false(setup.multi_spy.last_called_with_exactly(1, null, 'a'))
          assert_false(setup.multi_spy.last_called_with_exactly(null, 'a', 1))
          assert_false(setup.multi_spy.last_called_with_exactly('a', 1, null))
          assert_false(setup.multi_spy.last_called_with_exactly(null, null, null))
        )
      )
    )

    group('called_times()', func():
      test('can return true when spy was never called', func():
        var setup = build.call()
        assert_true(setup.multi_spy.called_times(0))
      )

      test('can return false when spy was never called', func():
        var setup = build.call()
        for i in range(1, 100):
          assert_false(setup.multi_spy.called_times(i))
      )

      test('returns false when not called enough times', func():
        var setup = build.call()
        setup.instance.takes_multiple_args(1, 2, 3)
        setup.instance.takes_multiple_args('a', 'b', 'c')

        assert_false(setup.multi_spy.called_times(0))
        assert_false(setup.multi_spy.called_times(1))
      )

      test('returns false when called too many times', func():
        var setup = build.call()
        setup.instance.takes_multiple_args(1, 2, 3)
        setup.instance.takes_multiple_args('a', 'b', 'c')

        assert_false(setup.multi_spy.called_times(3))
        assert_false(setup.multi_spy.called_times(4))
      )

      test('returns true when called exactly the right number of times', func():
        var setup = build.call()
        setup.instance.takes_multiple_args(1, 2, 3)
        setup.instance.takes_multiple_args('a', 'b', 'c')

        assert_true(setup.multi_spy.called_times(2))
      )
    )
  )

  group('mixed-spy tomfoolery', func():
    group('spying on functions with no implementation', func():
      test('spying on the class tracks usage across instances', func():
        var spy_a = spy(MockSpyClass.returns_a)
        var spy_b = spy(MockSpyClass.returns_b)
        var spy_str = spy(MockSpyClass.returns_string)

        var instance_1 = MockSpyClass.new()
        var instance_2 = MockSpyClass.new()

        assert_false(spy_a.called)
        assert_false(spy_b.called)
        assert_false(spy_str.called)

        instance_1.returns_a()
        assert_true(spy_a.called)
        assert_false(spy_b.called)
        assert_false(spy_str.called)

        instance_2.returns_b()
        assert_true(spy_b.called)
        assert_false(spy_str.called)

        instance_1.returns_string('test')
        assert_true(spy_str.called)
      )

      test('spying on an instance tracks usage only for that instance', func():
        var instance_1 = MockSpyClass.new()
        var instance_2 = MockSpyClass.new()

        var spy_a = spy(instance_1.returns_a)
        var spy_b = spy(instance_2.returns_b)

        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_2.returns_a()
        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_1.returns_b()
        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_1.returns_a()
        instance_2.returns_b()
        assert_true(spy_a.called)
        assert_true(spy_b.called)
      )
    )

    group('spying on functions with a mock implementation', func():
      test('you can spy on a function before mocking its return', func():
        var test_spy = spy(MockSpyClass.returns_a)
        MockSpyClass.returns_a.returns('not a')

        var instance = MockSpyClass.new()

        assert_false(test_spy.called)
        var return_val = instance.returns_a()
        assert_true(test_spy.called)
        assert_equal(return_val, 'not a')
        assert_equal(test_spy.last_call.return_value, 'not a')
      )

      test('you can spy on a function after mocking its return', func():
        MockSpyClass.returns_a.returns('not a')
        var test_spy = spy(MockSpyClass.returns_a)

        var instance = MockSpyClass.new()

        assert_false(test_spy.called)
        var return_val = instance.returns_a()
        assert_true(test_spy.called)
        assert_equal(return_val, 'not a')
        assert_equal(test_spy.last_call.return_value, 'not a')
      )

      test('spying on the class tracks usages across instances', func():
        MockSpyClass.returns_a.returns('not a')
        MockSpyClass.returns_b.returns('not b')
        MockSpyClass.returns_string.returns(1)

        var spy_a = spy(MockSpyClass.returns_a)
        var spy_b = spy(MockSpyClass.returns_b)
        var spy_str = spy(MockSpyClass.returns_string)

        var instance_1 = MockSpyClass.new()
        var instance_2 = MockSpyClass.new()

        assert_false(spy_a.called)
        assert_false(spy_b.called)
        assert_false(spy_str.called)

        instance_1.returns_a()
        assert_true(spy_a.called)
        assert_false(spy_b.called)
        assert_false(spy_str.called)

        instance_2.returns_b()
        assert_true(spy_b.called)
        assert_false(spy_str.called)

        instance_1.returns_string('test')
        assert_true(spy_str.called)
      )

      test('spying on an instance tracks usage only for that instance', func():
        MockSpyClass.returns_a.returns('not a')
        MockSpyClass.returns_b.returns('not b')
        MockSpyClass.returns_string.returns(1)

        var instance_1 = MockSpyClass.new()
        var instance_2 = MockSpyClass.new()

        var spy_a = spy(instance_1.returns_a)
        var spy_b = spy(instance_2.returns_b)

        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_2.returns_a()
        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_1.returns_b()
        assert_false(spy_a.called)
        assert_false(spy_b.called)

        instance_1.returns_a()
        instance_2.returns_b()
        assert_true(spy_a.called)
        assert_true(spy_b.called)
      )
    )

    group('spying on functions using the default implementation', func():
      group('functions that do not depend on constructor args', func():
        test('spying on the class tracks usage across instances', func():
          MockSpyClass.use_defaults()

          var spy_a = spy(MockSpyClass.returns_a)
          var spy_b = spy(MockSpyClass.returns_b)
          var spy_str = spy(MockSpyClass.returns_string)

          var instance_1 = MockSpyClass.new()
          var instance_2 = MockSpyClass.new()

          assert_false(spy_a.called)
          assert_false(spy_b.called)
          assert_false(spy_str.called)

          instance_1.returns_a()
          assert_true(spy_a.called)
          assert_false(spy_b.called)
          assert_false(spy_str.called)

          instance_2.returns_b()
          assert_true(spy_b.called)
          assert_false(spy_str.called)

          instance_1.returns_string('test')
          assert_true(spy_str.called)
        )

        test('spying on the instance tracks usage only of that instance', func():
          MockSpyClass.use_defaults()
          var instance_1 = MockSpyClass.new()
          var instance_2 = MockSpyClass.new()
          var spy_a = spy(instance_1.returns_a)
          var spy_b = spy(instance_2.returns_b)

          assert_false(spy_a.called)
          assert_false(spy_b.called)

          instance_2.returns_a()
          assert_false(spy_a.called)
          assert_false(spy_b.called)

          instance_1.returns_b()
          assert_false(spy_a.called)
          assert_false(spy_b.called)

          instance_1.returns_a()
          instance_2.returns_b()
          assert_true(spy_a.called)
          assert_true(spy_b.called)
        )
      )

      group('functions that do depend on constructor args', func():
        test('spying on the class tracks usages across instances', func():
          MockSpyClass.use_defaults()
          var init_class_spy = spy(MockSpyClass.returns_init_string)

          var instance_a = MockSpyClass.new('a')
          var instance_b = MockSpyClass.new('b')

          assert_true(init_class_spy.called_times(0))

          var ret_a = instance_a.returns_init_string()
          assert_true(init_class_spy.called_times(1))

          var ret_b = instance_b.returns_init_string()
          assert_true(init_class_spy.called_times(2))
          
          assert_true(ret_a != ret_b)
          assert_equal(init_class_spy.first_call.return_value, ret_a)
          assert_equal(init_class_spy.last_call.return_value, ret_b)
        )

        test('spying on the instances does not track usage accross instances', func():
          MockSpyClass.use_defaults()
          var instance_a = MockSpyClass.new('a')
          var instance_b = MockSpyClass.new('b')

          var spy_a = spy(instance_a.returns_init_string)
          var spy_b = spy(instance_b.returns_init_string)
          assert_true(spy_a.called_times(0))
          assert_true(spy_b.called_times(0))

          var ret_a = instance_a.returns_init_string()
          assert_true(spy_a.called_times(1))
          assert_true(spy_b.called_times(0))

          var ret_b_1 = instance_b.returns_init_string()
          var ret_b_2 = instance_b.returns_init_string()
          assert_true(spy_a.called_times(1))
          assert_true(spy_b.called_times(2))
        )
      )
    )

    group('spying on mock classes with defaults mixed with mock implementations', func():
      group('spying on a mocked function', func():
        test('spying on the class tracks usages across instances', func():
          MockSpyClass.use_defaults()
          MockSpyClass.returns_init_string.returns('q')

          var spy_str = spy(MockSpyClass.returns_init_string)
          var instance_a = MockSpyClass.new('a')
          var instance_b = MockSpyClass.new('b')
          assert_true(spy_str.called_times(0))

          # Seems like I'm not respecting the mock return here. Or rather TDSpy.invoke() doesn't...
          var ret_a = instance_a.returns_init_string()
          assert_true(spy_str.called_times(1))

          var ret_b = instance_b.returns_init_string()
          assert_true(spy_str.called_times(2))

          assert_equal(ret_a, 'q')
          assert_equal(ret_b, 'q')
        )

        test('spying on an instance tracks usage across instances', func():
          MockSpyClass.use_defaults()
          MockSpyClass.returns_init_string.returns('q')

          var instance_a = MockSpyClass.new('a')
          var instance_b = MockSpyClass.new('b')
          var spy_a = spy(instance_a.returns_init_string)
          var spy_b = spy(instance_b.returns_init_string)
          assert_true(spy_a.called_times(0))
          assert_true(spy_b.called_times(0))

          var ret_a = instance_a.returns_init_string()
          assert_true(spy_a.called_times(1))
          assert_true(spy_b.called_times(0))

          var ret_b_1 = instance_b.returns_init_string()
          var ret_b_2 = instance_b.returns_init_string()
          assert_true(spy_a.called_times(1))
          assert_true(spy_b.called_times(2))

          assert_equal(ret_a, 'q')
          assert_equal(ret_b_1, 'q')
          assert_equal(ret_b_2, 'q')
        )
      )

      group('spying on an unmocked function', func():
        group('functions that do not depend on constructor args', func():
          test('spying on the class track usage across instances', func():
            MockSpyClass.use_defaults()
            var class_spy = spy(MockSpyClass.returns_string)
            var instance_a = MockSpyClass.new()
            var instance_b = MockSpyClass.new()

            assert_true(class_spy.called_times(0))
            var ret_a = instance_a.returns_string('a')
            assert_equal(ret_a, 'a')
            assert_true(class_spy.last_called_with('a'))
            assert_true(class_spy.called_times(1))

            var ret_b = instance_b.returns_string('b')
            assert_equal(ret_b,  'b')
            assert_true(class_spy.ever_called_with('a'))
            assert_true(class_spy.last_called_with('b'))
            assert_true(class_spy.called_times(2))
          )

          test('spying on the instance tracks usage of the default implementation across instances', func():
            MockSpyClass.use_defaults()
            var instance_a = MockSpyClass.new()
            var instance_b = MockSpyClass.new()

            var spy_a = spy(instance_a.returns_string)
            var spy_b = spy(instance_b.returns_string)

            assert_true(spy_a.called_times(0))
            assert_true(spy_b.called_times(0))

            var ret_a = instance_a.returns_string('a')
            assert_true(spy_a.called_times(1))
            assert_true(spy_b.called_times(0))

            var ret_b = instance_b.returns_string('b')
            assert_true(spy_a.called_times(1))
            assert_true(spy_b.called_times(1))

            assert_true(spy_a.last_called_with('a'))
            assert_false(spy_a.ever_called_with('b'))

            assert_true(spy_b.last_called_with('b'))
            assert_false(spy_b.ever_called_with('a'))

            assert_equal(ret_a, 'a')
            assert_equal(ret_b, 'b')
          )
        )

        group('functions that do depend on constructor args', func():
          test('spying on the class does not track usage across instances', func():
            MockSpyClass.use_defaults()
            var class_spy = spy(MockSpyClass.returns_init_string)
            var instance_a = MockSpyClass.new('a')
            var instance_b = MockSpyClass.new('b')

            assert_true(class_spy.called_times(0))
            var ret_a = instance_a.returns_init_string()
            assert_equal(ret_a, 'a')
            assert_true(class_spy.called_times(1))

            var ret_b = instance_b.returns_init_string()
            assert_equal(ret_b,  'b')
            assert_true(class_spy.called_times(2))
          )
          
          test('spying on the instances does not track usage accross instances', func():
            MockSpyClass.use_defaults()
            var instance_a = MockSpyClass.new('a')
            var instance_b = MockSpyClass.new('b')

            var spy_a = spy(instance_a.returns_init_string)
            var spy_b = spy(instance_b.returns_init_string)

            assert_true(spy_a.called_times(0))
            assert_true(spy_b.called_times(0))

            var ret_a = instance_a.returns_init_string()
            assert_true(spy_a.called_times(1))
            assert_true(spy_b.called_times(0))

            var ret_b = instance_b.returns_init_string()
            assert_true(spy_a.called_times(1))
            assert_true(spy_b.called_times(1))

            assert_equal(ret_a, 'a')
            assert_equal(ret_b, 'b')
          )
        )
      )
    )
  )
