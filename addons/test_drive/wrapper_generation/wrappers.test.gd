class_name EditorSingletonWrapperTests extends TDTest

func test_drive():
  test('mocking EditorInspectorWrapper works', func(): 
    var Mock = mock(EditorInspectorWrapper)
    Mock.get_selected_path.returns('fake://selected/path')
    var path_spy = spy(Mock.get_selected_path)

    var wrapper = Mock.new()
    wrapper.get_selected_path()

    assert_true(path_spy.called_times(1))
    assert_equal(path_spy.last_call.return_value, 'fake://selected/path')
  )

  test('mocking EditorInterfaceWrapper works', func():
    var Mock = mock(EditorInterfaceWrapper)
    Mock.get_base_control.returns('test')
    var control_spy = spy(Mock.get_base_control)

    var wrapper = Mock.new()
    wrapper.get_base_control()

    assert_true(control_spy.called_times(1))
    assert_equal(control_spy.last_call.return_value, 'test')
  )

  test('mocking EditorPathsWrapper works', func():
    var Mock = mock(EditorPathsWrapper)
    Mock.get_data_dir.returns('fake://path')
    var path_spy = spy(Mock.get_data_dir)

    var wrapper = Mock.new()
    wrapper.get_data_dir()

    assert_true(path_spy.called_times(1))
    assert_equal(path_spy.last_call.return_value, 'fake://path')
  )


  test('mocking EditorSettingsWrapper works', func():
    var Mock = mock(EditorSettingsWrapper)
    Mock.get_setting.returns('potato')
    var setting_spy = spy(Mock.get_setting)
    var wrapper = Mock.new()
    wrapper.get_setting('this/is/a/fake/setting')

    assert_true(setting_spy.last_called_with('this/is/a/fake/setting'))
    assert_equal(setting_spy.last_call.return_value, 'potato')
  )

  test('mocking EditorUndoRedoManagerWrapper works', func(): 
    var Mock = mock(EditorUndoRedoManagerWrapper)
    Mock.get_history_undo_redo.returns('potato')
    var history_spy = spy(Mock.get_history_undo_redo)
    var wrapper = Mock.new()
    wrapper.get_history_undo_redo()

    assert_true(history_spy.called_times(1))
    assert_equal(history_spy.last_call.return_value, 'potato')  
  )

  test('mocking ScriptEditorWrapper works', func(): 
    var Mock = mock(ScriptEditorWrapper)
    Mock.get_history_undo_redo.returns('potato')
    var history_spy = spy(Mock.get_history_undo_redo)
    var wrapper = Mock.new()
    wrapper.get_history_undo_redo()

    assert_true(history_spy.called_times(1))
    assert_equal(history_spy.last_call.return_value, 'potato')  
  )
